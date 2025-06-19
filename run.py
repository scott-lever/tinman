#!/usr/bin/env python3
"""
Tinman Data Upload Application
Run this script to start the web server
"""

import uvicorn
from app.main import app

if __name__ == "__main__":
    print("🚀 Starting Tinman Data Upload Application...")
    print("📁 Upload files to: http://localhost:8000")
    print("🔍 API docs available at: http://localhost:8000/docs")
    print("💚 Health check at: http://localhost:8000/health")
    print("\nPress Ctrl+C to stop the server\n")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        reload=False,
        log_level="info"
    ) 