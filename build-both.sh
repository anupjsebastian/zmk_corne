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

# Create timestamp (same for both halves)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="$HOME/Downloads/zmk/$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

echo "Building left half..."

# Check for keymap syntax before building
if ! dtc -I dts -O dtb "$SCRIPT_DIR/config/corne.keymap" -o /dev/null 2>/dev/null; then
    echo "⚠ Warning: Keymap may have syntax issues"
fi

# Build left with verbose error output
if ! west build -p -d build/left -b nice_nano_v2 -s zmk/app -- \
  -DSHIELD="corne_left nice_view_adapter nice_view" \
  -DZMK_CONFIG="$SCRIPT_DIR/config" \
  -DCMAKE_PREFIX_PATH="$SCRIPT_DIR/zephyr/share/zephyr-package/cmake" \
  -DCONFIG_ZMK_STUDIO=y 2>&1 | tee /tmp/zmk_build_left.log; then
    echo "❌ Left build failed! Check /tmp/zmk_build_left.log for details"
    exit 1
fi

# Check left firmware details
LEFT_SIZE=$(stat -c%s "build/left/zephyr/zmk.uf2")
LEFT_HASH=$(md5sum "build/left/zephyr/zmk.uf2" | cut -d' ' -f1)

# Copy the left firmware
cp build/left/zephyr/zmk.uf2 "$OUTPUT_DIR/left_$TIMESTAMP.uf2"
echo "✓ Left half complete (Size: $LEFT_SIZE bytes, Hash: $LEFT_HASH)"

echo ""
echo "Building right half..."

# Build right with verbose error output
if ! west build -p -d build/right -b nice_nano_v2 -s zmk/app -- \
  -DSHIELD="corne_right nice_view_adapter nice_view" \
  -DZMK_CONFIG="$SCRIPT_DIR/config" \
  -DCMAKE_PREFIX_PATH="$SCRIPT_DIR/zephyr/share/zephyr-package/cmake" 2>&1 | tee /tmp/zmk_build_right.log; then
    echo "❌ Right build failed! Check /tmp/zmk_build_right.log for details"
    exit 1
fi

# Check right firmware details
RIGHT_SIZE=$(stat -c%s "build/right/zephyr/zmk.uf2")
RIGHT_HASH=$(md5sum "build/right/zephyr/zmk.uf2" | cut -d' ' -f1)

# Copy the right firmware
cp build/right/zephyr/zmk.uf2 "$OUTPUT_DIR/right_$TIMESTAMP.uf2"
echo "✓ Right half complete (Size: $RIGHT_SIZE bytes, Hash: $RIGHT_HASH)"

echo ""
echo "✓ Both halves built successfully!"
echo "Output directory: $OUTPUT_DIR"
echo "  - left_$TIMESTAMP.uf2"
echo "  - right_$TIMESTAMP.uf2"
echo ""
echo "📋 To flash: Copy each file to the corresponding keyboard half in bootloader mode"
echo "   The copy should take 2-5 seconds if flashing is working correctly"
