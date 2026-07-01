from pathlib import Path
import torch

# Paths

PROJECT_ROOT = Path(__file__).resolve().parent.parent

DATASET_ROOT = PROJECT_ROOT / "dataset" / "PlantVillage"

TRAIN_DIR = DATASET_ROOT / "train"
VAL_DIR = DATASET_ROOT / "val"

MODEL_DIR = PROJECT_ROOT / "models"

MODEL_DIR.mkdir(parents=True, exist_ok=True)

# Device

DEVICE = torch.device(
    "cuda" if torch.cuda.is_available() else "cpu"
)

# Dataset

NUM_CLASSES = 38

IMAGE_SIZE = 224

BATCH_SIZE = 32

NUM_WORKERS = 4

PIN_MEMORY = torch.cuda.is_available()

# Training

EPOCHS = 15

LEARNING_RATE = 1e-3

WEIGHT_DECAY = 1e-4

# Model

MODEL_NAME = "efficientnet_b0"

MODEL_PATH = MODEL_DIR / "best_model.pth"