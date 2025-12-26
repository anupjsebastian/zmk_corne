# ZMK Configuration Structure

This configuration follows ZMK best practices for advanced customization.

## Directory Structure

```
config/
├── behaviors.dtsi           # Custom behavior definitions
├── keypos_def/
│   └── keypos_42keys.h     # Key position definitions and macros
├── corne.keymap            # Main keymap file
├── corne.conf              # Configuration settings
└── west.yml                # ZMK dependencies
```

## File Descriptions

### `behaviors.dtsi`
Contains individual behavior definitions for each hold-tap key:

**Left Hand Home Row:**
- **hml_f**: F key → Left Control
- **hml_d**: D key → Available for configuration
- **hml_s**: S key → Available for configuration  
- **hml_a**: A key → Available for configuration

**Right Hand Home Row:**
- **hmr_j**: J key → Right Control
- **hmr_k**: K key → Available for configuration
- **hmr_l**: L key → Available for configuration
- **hmr_semi**: ; key → Available for configuration

**Special Keys:**
- **mt_esc**: ESC key (Caps Lock position) → Left GUI
- **mt_enter**: ENTER key (apostrophe position) → Right GUI

Key features per behavior:
- `flavor = "balanced"`: Balanced between tap and hold
- `tapping-term-ms`: Time to register a hold (280ms for home row, 200ms for special)
- `quick-tap-ms = 175`: Quick successive taps
- `require-prior-idle-ms`: Idle time before activation (150ms home row, 100ms special)
- `hold-trigger-on-release`: More reliable for fast typing
- `hold-trigger-key-positions`: Only triggers hold on opposite hand keys

### `keypos_def/keypos_42keys.h`
Key position reference for the 42-key Corne layout:
- Named constants for each key position
- Visual layout diagram
- Useful groupings (KEYS_L, KEYS_R, THUMBS)

Use these constants in behaviors for better readability.

### `corne.keymap`
Main keymap file with:
- Includes for custom behaviors
- Layer definitions
- Key bindings using custom behaviors

## Current Home Row Mods

### Active Configurations

**Left Hand:**
- **F key**: Tap for F, Hold for Left Ctrl (`&hml_f LCTRL F`)

**Right Hand:**
- **J key**: Tap for J, Hold for Right Ctrl (`&hmr_j RCTRL J`)

**Special Keys:**
- **ESC** (Caps Lock position): Tap for ESC, Hold for Left GUI (`&mt_esc LGUI ESC`)
- **ENTER** (apostrophe position): Tap for ENTER, Hold for Right GUI (`&mt_enter RGUI RET`)

### Available for Configuration

Each key has a dedicated behavior ready to use:
- `&hml_a` - A key (left pinky)
- `&hml_s` - S key (left ring)
- `&hml_d` - D key (left middle)
- `&hmr_k` - K key (right middle)
- `&hmr_l` - L key (right ring)
- `&hmr_semi` - ; key (right pinky)

## Adding More Home Row Mods

To activate additional home row mods, edit the bindings in `corne.keymap`:

```c
// Example: Full home row mods
&hml_a LGUI A     // A: Hold for GUI
&hml_s LALT S     // S: Hold for Alt
&hml_d LSHFT D    // D: Hold for Shift
&hml_f LCTRL F    // F: Hold for Ctrl (already active)

&hmr_j RCTRL J    // J: Hold for Ctrl (already active)
&hmr_k RSHFT K    // K: Hold for Shift
&hmr_l RALT L     // L: Hold for Alt
&hmr_semi RGUI SEMI // ;: Hold for GUI
```

Each behavior can be individually tuned in `behaviors.dtsi`.

## Customization Tips

1. **Adjust Timing**: Edit `tapping-term-ms` in `behaviors.dtsi` if mods trigger too easily or not easily enough
2. **Add More Behaviors**: Create new behaviors in `behaviors.dtsi` for different key groups
3. **Layer-Specific Behaviors**: Define behaviors that work differently per layer
4. **Combos**: Add combo definitions in a separate `combos.dtsi` file
5. **Macros**: Define macros in a separate `macros.dtsi` file

## Testing Changes

After editing:
1. Build firmware (locally or via GitHub Actions)
2. Flash to keyboard
3. Test the timing - adjust if needed
4. Commit working configurations

## Resources

- [ZMK Behaviors Documentation](https://zmk.dev/docs/behaviors)
- [Hold-Tap Configuration](https://zmk.dev/docs/behaviors/hold-tap)
- [Key Positions](https://zmk.dev/docs/config/system#key-positions)
