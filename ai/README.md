# 🌱 KrishiOS AI Module

This directory contains the complete Artificial Intelligence pipeline for KrishiOS.

The AI module is responsible for:

- Crop disease classification
- Disease severity estimation
- Explainable AI (Grad-CAM)
- TensorFlow Lite conversion
- FastAPI inference service
- Offline prediction
- Recommendation engine

---

# Directory Structure

```
ai
├── api
├── configs
├── dataset
├── inference
├── models
├── notebooks
├── outputs
├── scripts
├── tests
├── training
├── utils
├── requirements.txt
└── README.md
```

---

# Folder Responsibilities

## 📂 api/

REST API for the AI model.

Responsibilities:

- Load trained model
- Receive image from frontend
- Run inference
- Return prediction
- Return confidence
- Return remedy recommendation

Example files

```
main.py
routes.py
schemas.py
```

---

## 📂 configs/

Project configuration.

Contains

- Image size
- Batch size
- Epochs
- Learning rate
- Dataset paths
- Model paths

Example

```
config.py
paths.py
```

---

## 📂 dataset/

Local datasets.

Contains

```
PlantVillage/
```

Ignored by Git.

Never committed.

---

## 📂 inference/

Inference pipeline.

Responsibilities

- Load trained model
- Predict disease
- TensorFlow Lite inference
- Grad-CAM visualization

Example

```
predict.py
tflite_predict.py
gradcam.py
```

---

## 📂 models/

Stores trained models.

Examples

```
best_model.keras
model.tflite
labels.json
```

Ignored by Git.

---

## 📂 notebooks/

Research and experimentation.

Contains

- EDA
- Model experiments
- Visualization
- Hyperparameter tuning

---

## 📂 outputs/

Generated outputs.

Contains

- Confusion Matrix
- Accuracy graphs
- Training plots
- Grad-CAM images
- Evaluation reports

Ignored by Git.

---

## 📂 scripts/

Utility scripts.

Examples

```
dataset_check.py
split_dataset.py
download_dataset.py
convert_tflite.py
```

Usually executed once.

---

## 📂 tests/

Unit tests.

Tests

- Dataset loader
- Prediction
- Image preprocessing
- API

---

## 📂 training/

Model training pipeline.

Contains

```
dataset.py
train.py
evaluate.py
callbacks.py
```

Responsible for

- Data loading
- Training
- Validation
- Evaluation
- Saving best model

---

## 📂 utils/

Reusable helper functions.

Examples

```
logger.py
metrics.py
image_utils.py
visualization.py
```

---

# Workflow

```
Dataset
    ↓
Training
    ↓
Model
    ↓
Evaluation
    ↓
TensorFlow Lite
    ↓
Inference
    ↓
API
    ↓
Flutter
```

---

# Model Lifecycle

```
Leaf Image
      ↓
Image Preprocessing
      ↓
TensorFlow Model
      ↓
Disease Prediction
      ↓
Severity Prediction
      ↓
Recommendation Engine
      ↓
JSON Response
```

---

# Technologies

- TensorFlow
- TensorFlow Lite
- OpenCV
- FastAPI
- NumPy
- Pandas
- Scikit-learn
- Pillow
- Matplotlib

---

# Notes

- Do not commit datasets.
- Do not commit trained models.
- Keep utility functions inside `utils/`.
- Experimental code belongs in `notebooks/`.
- Production code belongs in `training/`, `inference/`, and `api/`.

By Zoro....