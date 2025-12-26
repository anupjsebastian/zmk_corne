# ZMK Configuration Quick Start Guide

## What You Have Now

Your Corne keyboard ZMK configuration is set up with:

```
corne/
├── .github/workflows/build.yml  # Automatic firmware builds on GitHub
├── config/
│   ├── corne.conf               # Keyboard settings
│   ├── corne.keymap            # Your keymap definition
│   └── west.yml                # ZMK dependencies
├── tools/
│   ├── keyboard_diagnostics.py  # Test keyboard connection
│   └── keymap_parser.py        # Parse and validate keymap
├── .venv/                       # Python virtual environment
├── .gitignore
└── README.md
```

## Important Notes About ZMK

**ZMK keyboards DO NOT allow extracting configuration from running firmware.**

- Configuration is compiled into binary firmware (.uf2 files)
- You must edit source files (corne.keymap) and rebuild
- The configuration I've created is a standard Corne layout as a starting point

## Quick Command Reference

### Activate Python Environment
```bash
source .venv/bin/activate
```

### Test Your Keyboard Connection
```bash
python tools/keyboard_diagnostics.py
```

### Validate Your Keymap
```bash
python tools/keymap_parser.py config/corne.keymap
```

### Build Firmware Locally (requires West & Zephyr)
```bash
# Initialize (first time only)
west init -l config/
west update

# Build left half
west build -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG="$(pwd)/config"

# Build right half  
west build --pristine -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG="$(pwd)/config"
```

### Build Firmware with GitHub Actions (Recommended)
1. Push this repo to GitHub
2. Enable Actions in repository settings
3. Push changes - firmware builds automatically
4. Download .uf2 files from Actions artifacts

## Flash Firmware to Keyboard

1. **Enter Bootloader Mode:**
   - Plug keyboard half into USB
   - Double-tap the reset button
   - "NICENANO" USB drive should appear

2. **Copy Firmware:**
   - Drag and drop the appropriate .uf2 file to the drive
   - `corne_left_nice_nano_v2.uf2` → left half
   - `corne_right_nice_nano_v2.uf2` → right half

3. **Wait:**
   - Drive will auto-eject when complete
   - Keyboard will restart with new firmware

4. **Repeat for Other Half**

## Common Customizations

### Edit Keymap

Edit `config/corne.keymap` to change key positions.

**Key Binding Syntax:**
```
&kp KEY        // Regular key press
&mo LAYER      // Momentary layer activation (hold)
&lt LAYER KEY  // Layer-tap (hold for layer, tap for key)
&mt MOD KEY    // Mod-tap (hold for modifier, tap for key)
&trans         // Pass through to lower layer
&none          // No operation
```

**Example:**
```
&kp A          // Letter A
&kp ENTER      // Enter key
&mo 1          // Hold to activate layer 1
&lt 1 SPACE    // Hold for layer 1, tap for space
&mt LSHFT TAB  // Hold for shift, tap for tab
```

### Enable RGB Underglow

Uncomment in `config/corne.conf`:
```
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_WS2812_STRIP=y
```

Add RGB controls to keymap:
```
#include <dt-bindings/zmk/rgb.h>

// In your keymap bindings:
&rgb_ug RGB_TOG  // Toggle RGB
&rgb_ug RGB_BRI  // Brightness increase
&rgb_ug RGB_BRD  // Brightness decrease
```

### Enable OLED Display

Uncomment in `config/corne.conf`:
```
CONFIG_ZMK_DISPLAY=y
```

### Add Rotary Encoders

Uncomment in `config/corne.conf`:
```
CONFIG_EC11=y
CONFIG_EC11_TRIGGER_GLOBAL_THREAD=y
```

### Bluetooth Profile Switching

Already included in lower layer:
```
&bt BT_CLR      // Clear all bonds
&bt BT_SEL 0    // Select profile 0
&bt BT_SEL 1    // Select profile 1
// ... up to profile 4
```

## Advanced Customizations

### Home Row Mods
```
// Hold for modifier, tap for key
&mt LCTRL A  &mt LALT S  &mt LGUI D  &mt LSHFT F
```

### Tap Dance
Requires custom behavior definition - see ZMK docs.

### Combos
Create key combinations that trigger different keys:

```c
/ {
    combos {
        compatible = "zmk,combos";
        combo_esc {
            timeout-ms = <50>;
            key-positions = <0 1>;  // Q + W
            bindings = <&kp ESC>;
        };
    };
};
```

### Macros
```c
/ {
    macros {
        zed_em_kay: zed_em_kay {
            compatible = "zmk,behavior-macro";
            #binding-cells = <0>;
            bindings = <&kp Z &kp M &kp K>;
        };
    };
};
```

## Resources

- **ZMK Documentation:** https://zmk.dev/docs
- **ZMK Keycodes:** https://zmk.dev/docs/codes
- **ZMK Behaviors:** https://zmk.dev/docs/behaviors
- **Corne Info:** https://github.com/foostan/crkbd
- **nice!nano:** https://nicekeyboards.com/docs/nice-nano/

## Troubleshooting

### Keyboard not detected in bootloader mode
- Try different USB cable (must support data, not just charging)
- Try different USB port
- Press reset button twice quickly

### GitHub Actions build fails
- Check syntax in keymap file
- Verify all included files exist
- Check Actions log for specific errors

### Keys not working after flash
- Ensure correct .uf2 for each half (left/right)
- Re-flash both halves
- Check battery connection (for wireless)
- Try resetting Bluetooth pairing

### Changes not taking effect
- Must rebuild firmware after editing config
- Must flash new .uf2 files to keyboard
- Clear Bluetooth bonds if behavior is inconsistent

## Next Steps

1. **Test the default layout** - Try typing with current config
2. **Plan your modifications** - Decide what keys you want where
3. **Edit the keymap** - Modify `config/corne.keymap`
4. **Build firmware** - Use GitHub Actions or local build
5. **Flash and test** - Flash new firmware and try it out
6. **Iterate** - Refine based on usage

## Git Workflow

```bash
# Make changes to config files
git add config/
git commit -m "Update keymap: add home row mods"
git push

# GitHub Actions will automatically build firmware
# Download .uf2 files from Actions > latest run > Artifacts
```

Happy customizing! 🎹
