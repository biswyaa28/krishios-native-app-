"""Utility functions module for PyTorch training in KrishiOS.

This module provides common helper utilities for setting random seeds, calculating
metrics, counting model parameters, saving and loading checkpoints, and plotting
training curves.
"""

import random
from pathlib import Path
from typing import Any, Dict, Optional, Union
import matplotlib.pyplot as plt
import numpy as np
import torch


def set_seed(seed: int = 42) -> None:
    """Sets random seeds for reproducibility across random, numpy, and torch.

    Args:
        seed: The integer seed value to use.
    """
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    
    # Ensure deterministic behavior in CUDA operations
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False


def calculate_accuracy(outputs: torch.Tensor, targets: torch.Tensor) -> float:
    """Computes the classification accuracy ratio for a batch of predictions.

    Args:
        outputs: The raw model outputs (logits) of shape (batch_size, num_classes).
        targets: The ground truth labels of shape (batch_size).

    Returns:
        The accuracy as a float value between 0.0 and 1.0.
    """
    if outputs.size(0) == 0:
        return 0.0
    _, predicted = torch.max(outputs, dim=1)
    correct = (predicted == targets).sum().item()
    return correct / targets.size(0)


def count_trainable_parameters(model: torch.nn.Module) -> int:
    """Counts the number of trainable parameters in a PyTorch model.

    Args:
        model: The model whose parameters are to be counted.

    Returns:
        The count of trainable parameters.
    """
    return sum(p.numel() for p in model.parameters() if p.requires_grad)


def save_checkpoint(state: Dict[str, Any], filepath: Union[str, Path]) -> None:
    """Saves a training checkpoint state dictionary to a file.

    Args:
        state: Dictionary containing training state (e.g. model state dict,
            optimizer state dict, epoch, etc.).
        filepath: Target destination file path.
    """
    path = Path(filepath)
    path.parent.mkdir(parents=True, exist_ok=True)
    torch.save(state, path)


def load_checkpoint(
    filepath: Union[str, Path],
    model: torch.nn.Module,
    optimizer: Optional[torch.optim.Optimizer] = None,
    device: Optional[torch.device] = None,
) -> Dict[str, Any]:
    """Loads a saved checkpoint state dictionary and restores model/optimizer weights.

    Args:
        filepath: Path to the checkpoint file.
        model: The model to load weights into.
        optimizer: The optimizer to load states into.
        device: The target device to map the loaded tensors.

    Returns:
        The loaded checkpoint state dictionary.
    """
    path = Path(filepath)
    if not path.exists():
        raise FileNotFoundError(f"Checkpoint file not found: {path}")

    # Load checkpoint mapping to specified device or CPU
    map_location = device if device is not None else torch.device("cpu")
    checkpoint = torch.load(path, map_location=map_location)

    # Restore weights
    model.load_state_dict(checkpoint["model_state_dict"])
    if optimizer is not None and "optimizer_state_dict" in checkpoint:
        optimizer.load_state_dict(checkpoint["optimizer_state_dict"])

    return checkpoint


def plot_training_history(history: Dict[str, list], save_path: Union[str, Path]) -> None:
    """Plots and saves the training history curves (Loss and Accuracy).

    Args:
        history: Dictionary containing lists of metric values per epoch:
            {
                "train_loss": [...],
                "val_loss": [...],
                "train_acc": [...],
                "val_acc": [...]
            }
        save_path: The destination image file path (e.g. 'history.png').
    """
    epochs = range(1, len(history["train_loss"]) + 1)
    
    plt.figure(figsize=(14, 5))
    
    # Loss plot
    plt.subplot(1, 2, 1)
    plt.plot(epochs, history["train_loss"], label="Train Loss", marker="o", color="#3b82f6")
    plt.plot(epochs, history["val_loss"], label="Val Loss", marker="x", color="#ef4444")
    plt.title("Training & Validation Loss", fontsize=12, fontweight="bold")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.legend()
    plt.grid(True, linestyle="--", alpha=0.6)
    
    # Accuracy plot
    plt.subplot(1, 2, 2)
    plt.plot(epochs, history["train_acc"], label="Train Acc", marker="o", color="#10b981")
    plt.plot(epochs, history["val_acc"], label="Val Acc", marker="x", color="#f59e0b")
    plt.title("Training & Validation Accuracy", fontsize=12, fontweight="bold")
    plt.xlabel("Epoch")
    plt.ylabel("Accuracy")
    plt.legend()
    plt.grid(True, linestyle="--", alpha=0.6)
    
    plt.tight_layout()
    
    # Create target directories if they do not exist
    plot_path = Path(save_path)
    plot_path.parent.mkdir(parents=True, exist_ok=True)
    
    plt.savefig(plot_path, dpi=150)
    plt.close()
