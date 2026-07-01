"""
Training and validation engine for KrishiOS.
"""

from typing import Tuple

import torch
from torch.utils.data import DataLoader
from tqdm.auto import tqdm

from .utils import calculate_accuracy


def train_one_epoch(
    model: torch.nn.Module,
    dataloader: DataLoader,
    criterion: torch.nn.Module,
    optimizer: torch.optim.Optimizer,
    device: torch.device,
    scaler: torch.amp.GradScaler | None = None,
) -> Tuple[float, float]:

    if scaler is None:
        scaler = torch.amp.GradScaler("cuda")

    model.train()

    running_loss = 0.0
    correct = 0
    total = 0

    device_type = "cuda" if device.type == "cuda" else "cpu"

    progress = tqdm(
        dataloader,
        desc="Training",
        leave=False,
    )

    for images, labels in progress:

        images = images.to(device, non_blocking=True)
        labels = labels.to(device, non_blocking=True)

        optimizer.zero_grad(set_to_none=True)

        with torch.amp.autocast(
            device_type=device_type,
            enabled=device.type == "cuda",
        ):

            outputs = model(images)

            loss = criterion(outputs, labels)

        scaler.scale(loss).backward()

        scaler.step(optimizer)

        scaler.update()

        running_loss += loss.item() * images.size(0)

        _, preds = torch.max(outputs, 1)

        correct += (preds == labels).sum().item()

        total += labels.size(0)

        progress.set_postfix(
            loss=f"{loss.item():.4f}",
            acc=f"{calculate_accuracy(outputs, labels)*100:.2f}%"
        )

    epoch_loss = running_loss / total

    epoch_acc = (correct / total) * 100

    return epoch_loss, epoch_acc


def validate(
    model: torch.nn.Module,
    dataloader: DataLoader,
    criterion: torch.nn.Module,
    device: torch.device,
) -> Tuple[float, float]:

    model.eval()

    running_loss = 0.0
    correct = 0
    total = 0

    device_type = "cuda" if device.type == "cuda" else "cpu"

    progress = tqdm(
        dataloader,
        desc="Validation",
        leave=False,
    )

    with torch.no_grad():

        for images, labels in progress:

            images = images.to(device, non_blocking=True)
            labels = labels.to(device, non_blocking=True)

            with torch.amp.autocast(
                device_type=device_type,
                enabled=device.type == "cuda",
            ):

                outputs = model(images)

                loss = criterion(outputs, labels)

            running_loss += loss.item() * images.size(0)

            _, preds = torch.max(outputs, 1)

            correct += (preds == labels).sum().item()

            total += labels.size(0)

            progress.set_postfix(
                loss=f"{loss.item():.4f}",
                acc=f"{calculate_accuracy(outputs, labels)*100:.2f}%"
            )

    val_loss = running_loss / total

    val_acc = (correct / total) * 100

    return val_loss, val_acc