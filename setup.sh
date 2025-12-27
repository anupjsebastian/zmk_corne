#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "================================================"
echo "ZMK Corne Keyboard Build Environment Setup"
echo "================================================"
echo ""

# Step 1: Create virtual environment with uv
echo "[1/3] Creating Python virtual environment with uv..."
if [ -d ".venv" ]; then
    echo "  ✓ Virtual environment already exists"
else
    uv venv .venv
    echo "  ✓ Virtual environment created"
fi
echo ""

# Step 2: Install Python dependencies
echo "[2/3] Installing Python dependencies (west, pyelftools, setuptools)..."
source .venv/bin/activate
uv pip install west pyelftools setuptools
echo "  ✓ Dependencies installed"
echo ""

# Step 3: Initialize and update west workspace
echo "[3/3] Initializing west workspace and fetching ZMK/Zephyr..."
if [ -d ".west" ]; then
    echo "  ℹ West workspace already initialized, updating..."
    west update
else
    echo "  Initializing west workspace..."
    west init -l config
    echo "  Fetching dependencies (this may take a few minutes)..."
    west update
fi
echo "  ✓ West workspace ready"
echo ""

echo "================================================"
echo "✓ Setup complete!"
echo "================================================"
echo ""
echo "You can now build your keyboard firmware:"
echo "  ./build-left.sh   - Build left half"
echo "  ./build-right.sh  - Build right half"
echo "  ./build-both.sh   - Build both halves"
echo ""
echo "Firmware will be output to: ~/Downloads/zmk/<timestamp>/"
