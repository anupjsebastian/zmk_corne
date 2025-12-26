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
Contains custom behavior definitions:
- **hml** (home_row_mod_left): Left-hand home row mods with optimized timing
- **hmr** (home_row_mod_right): Right-hand home row mods with optimized timing
- **mt_special**: Standard mod-tap for special keys (ESC, ENTER)

Key features:
- `flavor = "balanced"`: Balanced between tap and hold
- `tapping-term-ms = 280`: Time to register a hold
- `quick-tap-ms = 175`: Quick successive taps
- `require-prior-idle-ms = 150`: Requires idle time before activation
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

### Left Hand
- **F key**: Tap for F, Hold for Left Ctrl (`&hml LCTRL F`)

### Right Hand  
- **J key**: Tap for J, Hold for Right Ctrl (`&hmr RCTRL J`)

### Special Keys
- **ESC** (Caps Lock position): Tap for ESC, Hold for Left GUI (`&mt_special LGUI ESC`)
- **ENTER** (where ' was): Tap for ENTER, Hold for Right GUI (`&mt_special RGUI RET`)

## Adding More Home Row Mods

To add more home row modifiers, follow this pattern:

```c
// In the default_layer bindings:
&hml LSHIFT A    // Left hand: Hold A for Shift
&hmr RSHIFT SEMI // Right hand: Hold ; for Shift
&hml LALT S      // Left hand: Hold S for Alt
&hmr RALT L      // Right hand: Hold L for Alt
```

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
