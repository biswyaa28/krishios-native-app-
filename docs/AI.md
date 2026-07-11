# Artificial Intelligence System

This document describes the dataset composition, PyTorch architecture, training parameters, and TorchScript deployment targets for the KrishiOS leaf pathology classifier.

---

## 📊 Dataset & Model Architecture

### 1. Dataset (PlantVillage)
The neural network model is trained on the standard open-source **PlantVillage** dataset, containing 54,306 images of healthy and diseased crop leaves labeled across 38 unique class directories (e.g. apple, grape, tomato, potato).

### 2. Model Structure
*   **Base Network**: ResNet50 (or MobileNetV3-Large for lighter, mobile-optimized runtimes).
*   **Input Image Dimension**: 3 channels RGB, scaled to `224x224` pixels.
*   **Normalization Averages**:
    *   Mean: `[0.485, 0.456, 0.406]`
    *   Standard Deviation: `[0.229, 0.224, 0.225]`

---

## ⚡ PyTorch to TorchScript Pipeline

To run inference inside the FastAPI Python environment without dependencies on raw model files or code templates, the network is compiled using **TorchScript JIT**:

```
PyTorch Model (.pth) ➔ JIT Trace/Script ➔ Compiled Model (.ts) ➔ CPU Load on FastAPI
```

### 1. Trace Script Compilation
```python
import torch
import torchvision.models as models

# Initialize network structure and load weights
model = models.resnet50()
model.fc = torch.nn.Linear(model.fc.in_features, 38)
model.load_state_dict(torch.load("model.pth"))
model.eval()

# Execute JIT tracing with a dummy input tensor
dummy_input = torch.rand(1, 3, 224, 224)
traced_cell = torch.jit.trace(model, dummy_input)

# Save TorchScript binary file
traced_cell.save("ai/models/model.ts")
```

### 2. FastAPI Inference Logic
```python
# Load Model once on start
model = torch.jit.load("model.ts", map_location=torch.device("cpu"))

# Preprocess image data and execute model pass
input_tensor = preprocess(image).unsqueeze(0)
with torch.no_grad():
    outputs = model(input_tensor)
    probabilities = torch.nn.functional.softmax(outputs[0], dim=0)
    confidence, class_idx = torch.max(probabilities, dim=0)
```

---

## 🔮 Future Architecture (ONNX Target)

We are planning to transition the TorchScript runtime target to **ONNX Runtime (Open Neural Network Exchange)**:
*   Allows cross-platform native execution in C++ and Dart directly on client devices (bypassing the server REST call for offline usage).
*   Significantly lowers CPU memory footprints and speeds up mobile inference rates.
