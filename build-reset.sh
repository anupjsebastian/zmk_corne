#!/usr/bin/env bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Activate virtual environment
source .venv/bin/activate

# Set up environment variables
export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
export GNUARMEMB_TOOLCHAIN_PATH=/nix/store/zl327dqnvg3ynlpdhpphm1cppassbnq4-gcc-arm-embedded-14.3.rel1

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="$HOME/Downloads/zmk/$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

echo "Building settings_reset firmware for nice!nano v2..."
echo "⚠️  This firmware will clear all settings and Bluetooth pairings!"
echo ""

# Build settings reset firmware
if ! west build -p -d build/reset -b nice_nano_v2 -s zmk/app -- \
  -DSHIELD="settings_reset" \
  -DCMAKE_PREFIX_PATH="$SCRIPT_DIR/zephyr/share/zephyr-package/cmake" 2>&1 | tee /tmp/zmk_build_reset.log; then
    echo "❌ Build failed! Check /tmp/zmk_build_reset.log for details"
    exit 1
fi

# Check firmware details
FIRMWARE_SIZE=$(stat -c%s "build/reset/zephyr/zmk.uf2")
FIRMWARE_HASH=$(md5sum "build/reset/zephyr/zmk.uf2" | cut -d' ' -f1)

# Copy the built firmware
cp build/reset/zephyr/zmk.uf2 "$OUTPUT_DIR/settings_reset_$TIMESTAMP.uf2"

echo ""
echo "✓ Settings reset firmware built successfully!"
echo "Output: $OUTPUT_DIR/settings_reset_$TIMESTAMP.uf2"
echo "Size: $FIRMWARE_SIZE bytes"
echo "Hash: $FIRMWARE_HASH"
echo ""
echo "📋 RESET PROCEDURE:"
echo "   1. Flash this settings_reset firmware to LEFT half"
echo "   2. Flash this settings_reset firmware to RIGHT half"
echo "   3. Flash normal left_*.uf2 firmware to LEFT half"
echo "   4. Flash normal right_*.uf2 firmware to RIGHT half"
echo "   5. Remove/forget keyboard from all paired devices"
echo "   6. Re-pair the keyboard"
echo ""
echo "⚠️  NOTE: Bluetooth is DISABLED in this firmware to prevent"
echo "   auto-pairing. Flash normal firmware to restore functionality."
