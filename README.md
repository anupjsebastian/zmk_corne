# Corne ZMK Configuration

This is my personal ZMK firmware configuration for the Corne (CRKBD) keyboard.

## Features

- 3x6 column staggered split keyboard with 3 thumb keys per side
- Wireless (Bluetooth) support via nice!nano v2 controller
- Three layers: Default (QWERTY), Lower (Numbers & Navigation), Raise (Symbols)
- Bluetooth profile switching on Lower layer
- Optimized debounce settings for faster response
- Power management with sleep mode

## Layout

### Default Layer (QWERTY)
```
┌─────┬─────┬─────┬─────┬─────┬─────┐       ┌─────┬─────┬─────┬─────┬─────┬─────┐
│ TAB │  Q  │  W  │  E  │  R  │  T  │       │  Y  │  U  │  I  │  O  │  P  │BSPC │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│CTRL │  A  │  S  │  D  │  F  │  G  │       │  H  │  J  │  K  │  L  │  ;  │  '  │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│  Z  │  X  │  C  │  V  │  B  │       │  N  │  M  │  ,  │  .  │  /  │ ESC │
└─────┴─────┴─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │ GUI │LOWER│SPACE│       │ENTER│RAISE│ ALT │
                  └─────┴─────┴─────┘       └─────┴─────┴─────┘
```

### Lower Layer (Numbers & Navigation)
```
┌─────┬─────┬─────┬─────┬─────┬─────┐       ┌─────┬─────┬─────┬─────┬─────┬─────┐
│ TAB │  1  │  2  │  3  │  4  │  5  │       │  6  │  7  │  8  │  9  │  0  │BSPC │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│BTCLR│ BT1 │ BT2 │ BT3 │ BT4 │ BT5 │       │ ←   │ ↓   │ ↑   │ →   │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│     │     │     │     │     │       │     │     │     │     │     │     │
└─────┴─────┴─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │ GUI │     │SPACE│       │ENTER│     │ ALT │
                  └─────┴─────┴─────┘       └─────┴─────┴─────┘
```

### Raise Layer (Symbols)
```
┌─────┬─────┬─────┬─────┬─────┬─────┐       ┌─────┬─────┬─────┬─────┬─────┬─────┐
│ TAB │  !  │  @  │  #  │  $  │  %  │       │  ^  │  &  │  *  │  (  │  )  │BSPC │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│CTRL │     │     │     │     │     │       │  -  │  =  │  [  │  ]  │  \  │  `  │
├─────┼─────┼─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│     │     │     │     │     │       │  _  │  +  │  {  │  }  │  |  │  ~  │
└─────┴─────┴─────┼─────┼─────┼─────┤       ├─────┼─────┼─────┼─────┴─────┴─────┘
                  │ GUI │     │SPACE│       │ENTER│     │ ALT │
                  └─────┴─────┴─────┘       └─────┴─────┴─────┘
```

## Building Firmware

### Using GitHub Actions (Recommended)

1. Fork this repository
2. Enable GitHub Actions in your fork
3. Push changes to trigger automatic builds
4. Download firmware files from the Actions artifacts

### Building Locally

Prerequisites:
- West build tool
- Zephyr SDK
- ARM toolchain

```bash
# Initialize west workspace
west init -l config/

# Update dependencies
west update

# Build left half
west build -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG="$(pwd)/config"

# Build right half
west build --pristine -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG="$(pwd)/config"
```

## Flashing Firmware

1. Plug in the keyboard half via USB
2. Double-tap the reset button to enter bootloader mode
3. A USB drive named "NICENANO" should appear
4. Copy the corresponding `.uf2` file to the drive
5. The drive will automatically eject when flashing is complete
6. Repeat for the other half

## Configuration Files

- `config/corne.keymap` - Keymap definition with all layers
- `config/corne.conf` - Keyboard configuration settings
- `config/west.yml` - West manifest for ZMK dependencies
- `.github/workflows/build.yml` - GitHub Actions workflow for automatic builds

## Customization

### Modifying the Keymap

Edit `config/corne.keymap` to change key positions. The keymap uses ZMK's devicetree syntax.

Common keycodes:
- `&kp KEY` - Key press (e.g., `&kp A`, `&kp ENTER`)
- `&mo LAYER` - Momentary layer activation (e.g., `&mo 1`)
- `&lt LAYER KEY` - Layer-tap (hold for layer, tap for key)
- `&mt MOD KEY` - Mod-tap (hold for modifier, tap for key)
- `&trans` - Transparent (pass through to lower layer)
- `&none` - No operation

Bluetooth controls:
- `&bt BT_CLR` - Clear all bluetooth bonds
- `&bt BT_SEL 0-4` - Select bluetooth profile 0-4

### Enabling Optional Features

Edit `config/corne.conf` to enable features:

**RGB Underglow:**
```
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_WS2812_STRIP=y
```

**OLED Display:**
```
CONFIG_ZMK_DISPLAY=y
```

**Rotary Encoders:**
```
CONFIG_EC11=y
CONFIG_EC11_TRIGGER_GLOBAL_THREAD=y
```

## Resources

- [ZMK Documentation](https://zmk.dev/)
- [ZMK Keycodes](https://zmk.dev/docs/codes)
- [ZMK Behaviors](https://zmk.dev/docs/behaviors)
- [Corne Keyboard Info](https://github.com/foostan/crkbd)

## License

MIT License - Feel free to use and modify as needed.
