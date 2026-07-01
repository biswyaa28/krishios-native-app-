"""Training entrypoint script for KrishiOS.

This script coordinates the training and validation pipelines. It builds the dataset,
model, loss, optimizer, learning rate scheduler, and runs the training loop,
saving checkpoints and plotting metrics.
"""

import argparse
from pathlib import Path
import torch
import torch.nn as nn
from torch.optim import AdamW
from torch.optim.lr_scheduler import ReduceLROnPlateau

# Attempt imports using package structure, fallback to local directory imports
try:
    from training.dataset import create_dataset_and_loaders
    from training.model import build_model
    from training.engine import train_one_epoch, validate
    from training.utils import (
        set_seed,
        save_checkpoint,
        count_trainable_parameters,
        plot_training_history,
    )
except ImportError:
    from dataset import create_dataset_and_loaders
    from model import build_model
    from engine import train_one_epoch, validate
    from utils import (
        set_seed,
        save_checkpoint,
        count_trainable_parameters,
        plot_training_history,
    )

# Attempt to load project configuration, fallback to default constants if unavailable
try:
    from configs.config import (
        TRAIN_DIR,
        VAL_DIR,
        IMAGE_SIZE,
        BATCH_SIZE,
        NUM_WORKERS,
        EPOCHS,
        LEARNING_RATE,
        WEIGHT_DECAY,
        NUM_CLASSES,
        MODEL_PATH,
        DEVICE,
    )
except ImportError:
    # Safe fallback defaults
    TRAIN_DIR = Path("dataset/PlantVillage/train")
    VAL_DIR = Path("dataset/PlantVillage/val")
    IMAGE_SIZE = 224
    BATCH_SIZE = 32
    NUM_WORKERS = 4
    EPOCHS = 15
    LEARNING_RATE = 1e-3
    WEIGHT_DECAY = 1e-4
    NUM_CLASSES = 38
    MODEL_PATH = Path("models/best_model.pth")
    DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")


def main() -> None:
    """Main execution function to run the model training pipeline."""
    parser = argparse.ArgumentParser(description="Train EfficientNet-B0 on PlantVillage dataset.")
    parser.add_argument(
        "--train-dir",
        type=str,
        default=str(TRAIN_DIR),
        help="Path to training data directory."
    )
    parser.add_argument(
        "--val-dir",
        type=str,
        default=str(VAL_DIR),
        help="Path to validation data directory."
    )
    parser.add_argument(
        "--epochs",
        type=int,
        default=EPOCHS,
        help="Number of training epochs."
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=BATCH_SIZE,
        help="Batch size for training."
    )
    parser.add_argument(
        "--lr",
        type=float,
        default=LEARNING_RATE,
        help="Learning rate."
    )
    parser.add_argument(
        "--weight-decay",
        type=float,
        default=WEIGHT_DECAY,
        help="Weight decay for AdamW."
    )
    parser.add_argument(
        "--image-size",
        type=int,
        default=IMAGE_SIZE,
        help="Input image resolution."
    )
    parser.add_argument(
        "--num-workers",
        type=int,
        default=NUM_WORKERS,
        help="Number of loader subprocesses."
    )
    parser.add_argument(
        "--num-classes",
        type=int,
        default=NUM_CLASSES,
        help="Number of target classes."
    )
    parser.add_argument(
        "--model-path",
        type=str,
        default=str(MODEL_PATH),
        help="Path to save the best model."
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=42,
        help="Random seed for reproducibility."
    )
    args = parser.parse_args()

    # Setup seed
    set_seed(args.seed)

    # Setup directory paths using Pathlib
    train_path = Path(args.train_dir)
    val_path = Path(args.val_dir)
    model_save_path = Path(args.model_path)

    # 1. Dataset loading
    print("[INFO] Setting up datasets and data loaders...")
    train_dataset, val_dataset, train_loader, val_loader = create_dataset_and_loaders(
        train_dir=train_path,
        val_dir=val_path,
        image_size=args.image_size,
        batch_size=args.batch_size,
        num_workers=args.num_workers,
    )
    print(f"[INFO] Train samples: {len(train_dataset)}, Val samples: {len(val_dataset)}")
    
    # 2. Model Creation
    print("[INFO] Building model structure...")
    model = build_model(num_classes=args.num_classes)
    model = model.to(DEVICE)

    trainable_params = count_trainable_parameters(model)
    print(f"[INFO] Total trainable parameters: {trainable_params:,}")

    # 3. Criterion, Optimizer, Scheduler, and AMP Scaler
    criterion = nn.CrossEntropyLoss()
    optimizer = AdamW(model.parameters(), lr=args.lr, weight_decay=args.weight_decay)
    scheduler = ReduceLROnPlateau(optimizer, mode="min", factor=0.1, patience=3)
    scaler = torch.amp.GradScaler()

    # Track metrics history
    history = {
        "train_loss": [],
        "train_acc": [],
        "val_loss": [],
        "val_acc": []
    }
    
    best_val_loss = float("inf")

    # 4. Multi-epoch training loop
    print(f"[INFO] Initiating training loop on device: {DEVICE}")
    for epoch in range(1, args.epochs + 1):
        print(f"\n--- Epoch {epoch}/{args.epochs} ---")
        
        train_loss, train_acc = train_one_epoch(
            model=model,
            dataloader=train_loader,
            criterion=criterion,
            optimizer=optimizer,
            scaler=scaler,
            device=DEVICE,
        )
        
        val_loss, val_acc = validate(
            model=model,
            dataloader=val_loader,
            criterion=criterion,
            device=DEVICE,
        )
        
        current_lr = optimizer.param_groups[0]["lr"]
        
        # Step the learning rate scheduler based on validation loss
        scheduler.step(val_loss)

        # Log epoch history metrics
        history["train_loss"].append(train_loss)
        history["train_acc"].append(train_acc)
        history["val_loss"].append(val_loss)
        history["val_acc"].append(val_acc)

        print(
            f"Train Loss: {train_loss:.4f} | Train Acc: {train_acc:.4%}\n"
            f"Val Loss:   {val_loss:.4f} | Val Acc:   {val_acc:.4%}\n"
            f"LR:         {current_lr:.6f}"
        )

        # Save checkpoint if it yields the best validation loss
        if val_loss < best_val_loss:
            best_val_loss = val_loss
            print(f"[SAVING] Val loss improved. Writing best checkpoint to {model_save_path}")
            checkpoint_state = {
                "epoch": epoch,
                "model_state_dict": model.state_dict(),
                "optimizer_state_dict": optimizer.state_dict(),
                "val_loss": val_loss,
                "val_acc": val_acc,
                "history": history,
            }
            save_checkpoint(checkpoint_state, model_save_path)

    # 5. History Plotting
    plot_save_path = model_save_path.parent / "training_history.png"
    print(f"[INFO] Generating learning curves at {plot_save_path}")
    plot_training_history(history, plot_save_path)

    # 6. Final Metric Logging
    print("\n================ Training Execution Completed ================")
    print(f"Best Validation Loss Reached: {best_val_loss:.4f}")
    print(f"Final Train Accuracy: {history['train_acc'][-1]:.4%}")
    print(f"Final Validation Accuracy: {history['val_acc'][-1]:.4%}")
    print("==============================================================")


if __name__ == "__main__":
    main()
