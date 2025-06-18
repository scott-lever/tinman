from fastapi import FastAPI, File, UploadFile, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import os
import uuid
from datetime import datetime
import logging
from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Tinman Data Upload", version="1.0.0")

# Mount static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# Templates
templates = Jinja2Templates(directory="app/templates")

# Azure configuration
VAULT_URL = "https://tinman-poc-kv-uksouth.vault.azure.net/"
STORAGE_ACCOUNT_NAME = "tinmanpocstorage"
CONTAINER_NAME = "raw-uploads"

def get_azure_credentials():
    """Get Azure credentials and storage client"""
    try:
        # Use DefaultAzureCredential for local development
        credential = DefaultAzureCredential()
        
        # Get storage connection string from Key Vault
        secret_client = SecretClient(vault_url=VAULT_URL, credential=credential)
        connection_string = secret_client.get_secret("storage-connection-string").value
        
        # Create blob service client
        blob_service_client = BlobServiceClient.from_connection_string(connection_string)
        return blob_service_client
    except Exception as e:
        logger.error(f"Error getting Azure credentials: {e}")
        raise HTTPException(status_code=500, detail="Failed to connect to Azure services")

@app.get("/", response_class=HTMLResponse)
async def upload_page(request: Request):
    """Main upload page"""
    return templates.TemplateResponse("upload.html", {"request": request})

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    """Handle file upload to Azure Blob Storage"""
    try:
        # Validate file type
        allowed_extensions = {'.xlsx', '.xls', '.csv'}
        file_extension = os.path.splitext(file.filename)[1].lower()
        
        if file_extension not in allowed_extensions:
            raise HTTPException(
                status_code=400, 
                detail=f"Invalid file type. Allowed types: {', '.join(allowed_extensions)}"
            )
        
        # Validate file size (max 50MB)
        if file.size and file.size > 50 * 1024 * 1024:
            raise HTTPException(status_code=400, detail="File too large. Maximum size is 50MB")
        
        # Get Azure blob service client
        blob_service_client = get_azure_credentials()
        container_client = blob_service_client.get_container_client(CONTAINER_NAME)
        
        # Generate unique filename with timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        unique_id = str(uuid.uuid4())[:8]
        safe_filename = f"{timestamp}_{unique_id}_{file.filename}"
        
        # Upload file to blob storage
        blob_client = container_client.get_blob_client(safe_filename)
        
        # Read file content and upload
        content = await file.read()
        blob_client.upload_blob(content, overwrite=True)
        
        logger.info(f"File uploaded successfully: {safe_filename}")
        
        return {
            "message": "File uploaded successfully",
            "filename": safe_filename,
            "original_name": file.filename,
            "size": len(content),
            "upload_time": datetime.now().isoformat()
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error uploading file: {e}")
        raise HTTPException(status_code=500, detail="Failed to upload file")

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 