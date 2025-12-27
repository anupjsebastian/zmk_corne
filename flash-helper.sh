#!/usr/bin/env bash

echo "🔍 ZMK Flash Helper"
echo "=================="
echo ""

# Find the latest built firmware
LATEST_LEFT=$(ls -t ~/Downloads/zmk/*/left_*.uf2 2>/dev/null | head -1)
LATEST_RIGHT=$(ls -t ~/Downloads/zmk/*/right_*.uf2 2>/dev/null | head -1)

if [ -z "$LATEST_LEFT" ] && [ -z "$LATEST_RIGHT" ]; then
    echo "❌ No firmware files found. Run ./build-both.sh first"
    exit 1
fi

echo "Latest firmware builds:"
if [ -n "$LATEST_LEFT" ]; then
    LEFT_HASH=$(md5sum "$LATEST_LEFT" | cut -d' ' -f1)
    echo "  Left:  $LATEST_LEFT"
    echo "         Hash: $LEFT_HASH"
fi
if [ -n "$LATEST_RIGHT" ]; then
    RIGHT_HASH=$(md5sum "$LATEST_RIGHT" | cut -d' ' -f1)
    echo "  Right: $LATEST_RIGHT"
    echo "         Hash: $RIGHT_HASH"
fi

echo ""
echo "🔌 Waiting for keyboard in bootloader mode..."
echo "   (Double-tap reset button on your nice!nano)"
echo ""

# Wait for a device to be mounted
while true; do
    # Look for NICENANO drive
    DRIVE=$(ls /media/$USER/NICENANO 2>/dev/null || ls /run/media/$USER/NICENANO 2>/dev/null || ls /mnt/NICENANO 2>/dev/null)
    
    if [ -n "$DRIVE" ]; then
        MOUNT_POINT=$(df | grep NICENANO | awk '{print $6}')
        if [ -n "$MOUNT_POINT" ]; then
            echo "✓ Found keyboard at: $MOUNT_POINT"
            echo ""
            
            # Check what's currently on it
            if [ -f "$MOUNT_POINT/CURRENT.UF2" ]; then
                CURRENT_HASH=$(md5sum "$MOUNT_POINT/CURRENT.UF2" 2>/dev/null | cut -d' ' -f1)
                echo "Current firmware hash: $CURRENT_HASH"
            fi
            
            echo ""
            echo "Which half are you flashing?"
            echo "  1) Left"
            echo "  2) Right"
            read -p "Choice (1/2): " choice
            
            case $choice in
                1)
                    if [ -n "$LATEST_LEFT" ]; then
                        echo ""
                        echo "📦 Flashing LEFT firmware..."
                        echo "   This should take 2-5 seconds..."
                        START=$(date +%s)
                        
                        cp -v "$LATEST_LEFT" "$MOUNT_POINT/" && sync
                        
                        END=$(date +%s)
                        DURATION=$((END - START))
                        
                        echo ""
                        if [ $DURATION -lt 2 ]; then
                            echo "⚠️  WARNING: Flash completed in ${DURATION}s - TOO FAST!"
                            echo "   This likely means the firmware wasn't actually written."
                            echo "   Possible reasons:"
                            echo "   - Board already has this exact firmware"
                            echo "   - Board not in bootloader mode properly"
                            echo "   - File system cache issue"
                        else
                            echo "✅ Flash completed in ${DURATION}s - this looks good!"
                            echo "   The keyboard should reboot automatically"
                        fi
                    fi
                    ;;
                2)
                    if [ -n "$LATEST_RIGHT" ]; then
                        echo ""
                        echo "📦 Flashing RIGHT firmware..."
                        echo "   This should take 2-5 seconds..."
                        START=$(date +%s)
                        
                        cp -v "$LATEST_RIGHT" "$MOUNT_POINT/" && sync
                        
                        END=$(date +%s)
                        DURATION=$((END - START))
                        
                        echo ""
                        if [ $DURATION -lt 2 ]; then
                            echo "⚠️  WARNING: Flash completed in ${DURATION}s - TOO FAST!"
                            echo "   This likely means the firmware wasn't actually written."
                        else
                            echo "✅ Flash completed in ${DURATION}s - this looks good!"
                        fi
                    fi
                    ;;
                *)
                    echo "Invalid choice"
                    exit 1
                    ;;
            esac
            
            exit 0
        fi
    fi
    
    sleep 1
done
