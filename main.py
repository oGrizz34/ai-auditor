import os
import uvicorn
from fastapi import FastAPI

# Initialize FastAPI app
app = FastAPI()

# Root route to verify the app is running
@app.get("/")
def read_root():
    return {"message": "AI Auditor is running on Cloud Run!"}

# Main execution block to start the Uvicorn server
if __name__ == "__main__":
    # Get the PORT from environment variable (required for Cloud Run)
    port = int(os.environ.get("PORT", 8080))  # Default to 8080 if not set
    uvicorn.run(app, host="0.0.0.0", port=port)
