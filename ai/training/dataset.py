"""Dataset loading and preprocessing module for KrishiOS.

This module provides utility functions to load the PlantVillage dataset using
torchvision's ImageFolder. It supports data augmentation, resizing,
and normalization using ImageNet statistics.
"""

from pathlib import Path
from typing import Tuple, Union
import torch
from torch.utils.data import DataLoader
from torchvision import datasets, transforms


def create_dataset_and_loaders(
    train_dir: Union[str, Path],
    val_dir: Union[str, Path],
    image_size: int = 224,
    batch_size: int = 32,
    num_workers: int = 4,
) -> Tuple[datasets.ImageFolder, datasets.ImageFolder, DataLoader, DataLoader]:
    """Creates PyTorch Datasets and DataLoaders for train and validation splits.

    This function loads images using ImageFolder from the specified directories,
    applies training-specific data augmentations (horizontal flip, random rotation,
    color jitter), validation resizing, and standard ImageNet normalization.

    Args:
        train_dir: Path to the training dataset directory.
        val_dir: Path to the validation dataset directory.
        image_size: Target height and width for resizing images.
        batch_size: Number of samples per batch in DataLoaders.
        num_workers: Number of subprocesses to use for data loading.

    Returns:
        A tuple containing:
            - train_dataset: ImageFolder dataset for the training split.
            - val_dataset: ImageFolder dataset for the validation split.
            - train_loader: DataLoader for the training dataset.
            - val_loader: DataLoader for the validation dataset.
    """
    train_path = Path(train_dir)
    val_path = Path(val_dir)

    # Standard ImageNet normalization statistics
    mean = [0.485, 0.456, 0.406]
    std = [0.229, 0.224, 0.225]

    # Data augmentation and normalization for training
    train_transform = transforms.Compose([
        transforms.Resize((image_size, image_size)),
        transforms.RandomHorizontalFlip(),
        transforms.RandomRotation(15),
        transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
        transforms.ToTensor(),
        transforms.Normalize(mean=mean, std=std),
    ])

    # Validation transforms (only resize and normalization)
    val_transform = transforms.Compose([
        transforms.Resize((image_size, image_size)),
        transforms.ToTensor(),
        transforms.Normalize(mean=mean, std=std),
    ])

    # Load datasets using ImageFolder
    train_dataset = datasets.ImageFolder(root=str(train_path), transform=train_transform)
    val_dataset = datasets.ImageFolder(root=str(val_path), transform=val_transform)

    # Use pin_memory automatically if CUDA exists
    pin_memory = torch.cuda.is_available()

    # Create data loaders
    train_loader = DataLoader(
        train_dataset,
        batch_size=batch_size,
        shuffle=True,
        num_workers=num_workers,
        pin_memory=pin_memory,
    )

    val_loader = DataLoader(
        val_dataset,
        batch_size=batch_size,
        shuffle=False,
        num_workers=num_workers,
        pin_memory=pin_memory,
    )

    return train_dataset, val_dataset, train_loader, val_loader