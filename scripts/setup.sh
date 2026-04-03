#!/bin/bash
# Setup script for infra-platform

set -euo pipefail

echo "🚀 Setting up infra-platform..."

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ Virtual environment created"
fi

# Activate and install deps
source venv/bin/activate
pip install -r app/sample-app/requirements.txt
echo "✅ Dependencies installed"

echo "🎉 Setup complete! Run 'make run' to start."
