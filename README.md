# Tinman Data Processing Platform

A comprehensive data processing platform that allows users to upload Excel spreadsheets, process them with AI, and store the results in a database.

## 🏗️ Infrastructure

This project uses Terraform to manage Azure infrastructure:

- **Azure Storage Account**: `tinmanpocstorage` for blob storage
- **Azure OpenAI**: GPT-4.1 deployment for AI processing
- **Azure Key Vault**: Secure storage for secrets and credentials
- **Blob Containers**:
  - `raw-uploads`: New spreadsheet uploads
  - `processed`: Successfully processed files
  - `errors`: Files that failed processing
  - `archives`: Long-term storage

## 🚀 Web Application

### Features

- **Modern UI**: Clean, responsive interface built with Tailwind CSS
- **Drag & Drop**: Easy file upload with drag-and-drop functionality
- **File Validation**: Supports .xlsx, .xls, and .csv files (max 50MB)
- **Real-time Feedback**: Live status updates and progress indicators
- **Secure Upload**: Files are uploaded directly to Azure Blob Storage

### Quick Start

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Set up Azure Authentication**:
   ```bash
   # Login to Azure CLI
   az login
   
   # Set your subscription
   az account set --subscription "your-subscription-id"
   ```

3. **Run the Application**:
   ```bash
   python run.py
   ```

4. **Access the Application**:
   - Web Interface: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Health Check: http://localhost:8000/health

### Usage

1. Open your browser and navigate to http://localhost:8000
2. Drag and drop Excel files or click to browse
3. Review the selected files in the list
4. Click "Upload Files" to send them to Azure Blob Storage
5. Monitor the upload progress and status messages

## 🏗️ Infrastructure Management

### Prerequisites

- Azure CLI installed and authenticated
- Terraform installed
- Access to Azure subscription

### Deploy Infrastructure

1. **Navigate to Terraform directory**:
   ```bash
   cd terraform/azure
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

### Infrastructure Components

- **Resource Group**: `tinman-poc-rg` (UK South)
- **Storage Account**: `tinmanpocstorage`
- **Key Vault**: `tinman-poc-kv-uksouth`
- **OpenAI Service**: `tinman-openai` with GPT-4.1 deployment

## 🔧 Development

### Project Structure

```
tinman/
├── app/
│   ├── main.py              # FastAPI application
│   ├── templates/
│   │   └── upload.html      # Web interface
│   └── static/              # Static assets
├── terraform/
│   └── azure/               # Azure infrastructure
├── requirements.txt         # Python dependencies
├── run.py                  # Application runner
└── README.md               # This file
```

### Environment Variables

The application uses Azure DefaultAzureCredential for authentication. Make sure you're logged in with:

```bash
az login
```

### API Endpoints

- `GET /`: Main upload page
- `POST /upload`: File upload endpoint
- `GET /health`: Health check
- `GET /docs`: API documentation (Swagger UI)

## 🔒 Security

- All secrets are stored in Azure Key Vault
- Files are uploaded directly to Azure Blob Storage
- Authentication handled by Azure DefaultAzureCredential
- File type and size validation on both client and server

## 📝 Next Steps

1. **Data Processing Pipeline**: Implement CSV parsing and data extraction
2. **Diffbot Integration**: Add article extraction from URLs
3. **Supabase Integration**: Store processed data in database
4. **Chat Interface**: Build AI-powered chat interface
5. **Deployment**: Deploy to Azure App Service or Container Instances

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
