# AI Model Training & Export Guide

This guide details configuration, training, and deployment processes for the crop disease classification model.

---

## 1. Directory Structure

All training, configuration, and model script files are located inside `ai/`:
* **`configs/config.py`**: Shared hyperparameters (batch size, epochs, learning rate, image size).
* **`dataset/`**: Placeholder where the PlantVillage dataset is extracted.
* **`notebooks/`**: Research sheets (evaluation, visualization).
* **`training/`**: PyTorch pipeline modules (`dataset.py`, `model.py`, `engine.py`, `train.py`).

---

## 2. Training the Model

1. Activate your virtual environment and install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Download and extract the PlantVillage dataset to `ai/dataset/`.
3. Launch training using module package orchestrator:
   ```bash
   python -m training.train --epochs 10
   ```

---

## 3. Production Model Conversion (ONNX)

By default, the training pipeline writes TorchScript (`model.ts`). To deploy locally on mobile edge devices, the model must be exported to quantized ONNX format:

1. Convert PyTorch `.pth` weights to `.onnx`:
   ```bash
   python scripts/export_onnx.py
   ```
2. Quantize the ONNX output using INT8 configuration to compress binary size under 5MB.
3. Place the final `leaf_classifier.onnx` file under the Flutter assets directory `frontend/assets/models/`.
