# REST API Documentation

This document describes the FastAPI REST API endpoints available in the KrishiOS inference backend.

---

## 🔒 Base Configuration

*   **Development Host**: `0.0.0.0`
*   **Port**: `8080`
*   **Local Router URL**: `http://localhost:8080` (or `http://127.0.0.1:8080`)
*   **Android Emulator Loopback**: `http://10.0.2.2:8080`
*   **Interactive API Docs**: `/docs` (Swagger UI) or `/redoc` (ReDoc)

---

## 📥 Endpoints Directory

### 1. GET /health
Verify the status of the inference backend service.

*   **Request URL**: `GET http://localhost:8080/health`
*   **Headers**: None Required
*   **Success Response (200 OK)**:
    ```json
    {
      "status": "healthy",
      "model_loaded": true,
      "device": "cpu"
    }
    ```

---

### 2. POST /predict
Runs torchvision pre-processing and forward classification on crop leaf photos.

*   **Request URL**: `POST http://localhost:8080/predict`
*   **Content-Type**: `multipart/form-data`
*   **Request Body Form Data**:
    *   `file`: Binary file (JPEG/PNG image)
*   **Success Response (200 OK)**:
    ```json
    {
      "prediction": "Tomato Late Blight",
      "confidence": 0.942,
      "class_index": 21
    }
    ```
*   **Error Responses**:
    *   **400 Bad Request**: Uploaded file type is not supported:
        ```json
        { "detail": "Uploaded file must be an image." }
        ```
    *   **500 Internal Server Error**: Inference processing or reading failed:
        ```json
        { "detail": "Inference error: [error details]" }
        ```

---

## 🛠️ Errors & Response Statuses

The API standardizes on the following HTTP status codes:
*   `200 OK`: Request succeeded. Response body contains valid data schemas.
*   `400 Bad Request`: Payload content-type mismatch or missing fields.
*   `422 Unprocessable Entity`: Validation errors (FastAPI level validation failures).
*   `500 Internal Server Error`: Execution failures inside the python inference handler.

---

## 🔮 Future Endpoints (Planned)

*   `POST /predict-batch`: Multipart upload supporting list of image files to classify multiple crops concurrently.
*   `GET /metrics`: OpenMetrics telemetry details for model invocation rates, latency percentiles, and GPU memory usage.
