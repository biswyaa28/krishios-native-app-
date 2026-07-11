import os
import io
import torch
import torchvision.transforms as transforms
from PIL import Image
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="KrishiOS AI Inference Backend",
    description="REST API for real-time crop disease diagnosis",
    version="1.0.0"
)

# Enable CORS for cross-platform clients (Flutter web/mobile)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load TorchScript model
MODEL_PATH = os.path.join(os.path.dirname(__file__), "..", "ai", "models", "model.ts")
model = None

if os.path.exists(MODEL_PATH):
    try:
        # Load in evaluation mode on CPU
        model = torch.jit.load(MODEL_PATH, map_location=torch.device("cpu"))
        model.eval()
        print(f"[INFO] Successfully loaded TorchScript model from {MODEL_PATH}")
    except Exception as e:
        print(f"[ERROR] Failed to load TorchScript model: {e}")
else:
    print(f"[WARNING] Model file not found at {MODEL_PATH}. Inference endpoints will return mock predictions.")

# Image preprocessing transformations (matching ImageNet stats)
mean = [0.485, 0.456, 0.406]
std = [0.229, 0.224, 0.225]
preprocess = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=mean, std=std)
])

# Mock class names matching the PlantVillage 38 classes
CLASS_NAMES = [
    "Apple Scab", "Apple Black Rot", "Apple Cedar Rust", "Apple Healthy",
    "Blueberry Healthy", "Cherry Powdery Mildew", "Cherry Healthy",
    "Corn Common Rust", "Corn Gray Leaf Spot", "Corn Northern Leaf Blight", "Corn Healthy",
    "Grape Black Rot", "Grape Black Measles", "Grape Leaf Blight", "Grape Healthy",
    "Orange Huanglongbing (Citrus Greening)", "Peach Bacterial Spot", "Peach Healthy",
    "Pepper Bell Bacterial Spot", "Pepper Bell Healthy", "Potato Early Blight", "Potato Late Blight", "Potato Healthy",
    "Raspberry Healthy", "Soybean Healthy", "Squash Powdery Mildew", "Strawberry Leaf Scorch", "Strawberry Healthy",
    "Tomato Bacterial Spot", "Tomato Early Blight", "Tomato Late Blight", "Tomato Leaf Mold",
    "Tomato Septoria Leaf Spot", "Tomato Spider Mites", "Tomato Target Spot",
    "Tomato Yellow Leaf Curl Virus", "Tomato Mosaic Virus", "Tomato Healthy"
]

@app.get("/health")
def health_check():
    """Verify backend and model loaded status."""
    return {
        "status": "healthy",
        "model_loaded": model is not None,
        "device": "cpu"
    }

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """Diagnose crop disease from uploaded image file."""
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.")

    try:
        # Read image
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data)).convert("RGB")

        # Fallback to mock inference if model is missing
        if model is None:
            return {
                "prediction": "Tomato Late Blight",
                "confidence": 0.942,
                "message": "Demo mode (TorchScript model file missing)."
            }

        # Apply transformations
        input_tensor = preprocess(image).unsqueeze(0)

        # Run inference
        with torch.no_grad():
            outputs = model(input_tensor)
            probabilities = torch.nn.functional.softmax(outputs[0], dim=0)
            confidence, class_idx = torch.max(probabilities, dim=0)

        class_name = CLASS_NAMES[class_idx.item()] if class_idx.item() < len(CLASS_NAMES) else "Unknown Disease"

        return {
            "prediction": class_name,
            "confidence": float(confidence.item()),
            "class_index": int(class_idx.item())
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Inference error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
