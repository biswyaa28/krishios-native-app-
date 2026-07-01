"""Model architecture module for KrishiOS.

This module provides utility functions to construct the classification model
using a pretrained EfficientNet-B0 backbone with a custom classifier head.
"""

import torch
import torchvision.models as models
from torchvision.models.efficientnet import EfficientNet_B0_Weights


def build_model(num_classes: int, freeze_backbone: bool = True) -> torch.nn.Module:
    """Builds and configures an EfficientNet-B0 model for transfer learning.

    This function loads the pretrained EfficientNet-B0 model, freezes the
    feature extractor parameters (if freeze_backbone is True), and replaces the
    final classification layer (classifier) with a new Linear layer matching the
    target number of classes.

    Args:
        num_classes: The number of output classes for classification.
        freeze_backbone: If True, freezes all parameters in the feature
            backbone so they are not updated during training.

    Returns:
        The built PyTorch model ready for training.
    """
    # Load pretrained weights using the recommended torchvision API
    weights = EfficientNet_B0_Weights.DEFAULT
    model = models.efficientnet_b0(weights=weights)

    # Freeze backbone parameters
    if freeze_backbone:
        for param in model.features.parameters():
            param.requires_grad = False

    # Get input features from the original classifier's linear layer
    in_features = model.classifier[1].in_features

    # Replace classifier head while retaining Dropout layer for regularization
    model.classifier = torch.nn.Sequential(
        torch.nn.Dropout(p=0.2, inplace=True),
        torch.nn.Linear(in_features, num_classes),
    )

    return model