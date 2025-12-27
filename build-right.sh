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

echo "Building right half..."

# Build with verbose error output
if ! west build -p -d build/right -b nice_nano_v2 -s zmk/app -- \
  -DSHIELD="corne_right nice_view_adapter nice_view" \
  -DZMK_CONFIG="$SCRIPT_DIR/config" \
  -DCMAKE_PREFIX_PATH="$SCRIPT_DIR/zephyr/share/zephyr-package/cmake" 2>&1 | tee /tmp/zmk_build_right.log; then
    echo "❌ Build failed! Check /tmp/zmk_build_right.log for details"
    exit 1
fi

# Check firmware details
FIRMWARE_SIZE=$(stat -c%s "build/right/zephyr/zmk.uf2")
FIRMWARE_HASH=$(md5sum "build/right/zephyr/zmk.uf2" | cut -d' ' -f1)

# Copy the built firmware
cp build/right/zephyr/zmk.uf2 "$OUTPUT_DIR/right_$TIMESTAMP.uf2"

echo ""
echo "✓ Build complete!"
echo "Output: $OUTPUT_DIR/right_$TIMESTAMP.uf2"
echo "Size: $FIRMWARE_SIZE bytes"
echo "Hash: $FIRMWARE_HASH"
echo ""
echo "📋 To flash: Copy the file to your keyboard in bootloader mode"
echo "   The copy should take 2-5 seconds if flashing is working correctly"
