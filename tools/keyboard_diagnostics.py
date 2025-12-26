#!/usr/bin/env python3
"""
ZMK Keyboard Diagnostic Tool

This script helps diagnose and test your ZMK keyboard connection.
"""

import serial
import serial.tools.list_ports
import sys
import time


def list_serial_ports():
    """List all available serial ports."""
    ports = serial.tools.list_ports.comports()
    return ports


def find_keyboard_port():
    """Attempt to find the keyboard serial port."""
    ports = list_serial_ports()
    
    print("Available Serial Ports:")
    print("-" * 60)
    
    if not ports:
        print("No serial ports found.")
        return None
    
    for i, port in enumerate(ports, 1):
        print(f"{i}. {port.device}")
        print(f"   Description: {port.description}")
        print(f"   Hardware ID: {port.hwid}")
        if port.manufacturer:
            print(f"   Manufacturer: {port.manufacturer}")
        if port.product:
            print(f"   Product: {port.product}")
        print()
    
    # Look for common keyboard patterns
    keyboard_ports = []
    for port in ports:
        desc_lower = port.description.lower()
        hwid_lower = port.hwid.lower()
        
        if any(keyword in desc_lower or keyword in hwid_lower 
               for keyword in ['keyboard', 'nice', 'nano', 'usb serial']):
            keyboard_ports.append(port)
    
    if keyboard_ports:
        print("\nPotential keyboard port(s) found:")
        for port in keyboard_ports:
            print(f"  - {port.device}: {port.description}")
        return keyboard_ports[0].device
    
    return None


def test_connection(port, baudrate=115200):
    """Test serial connection to the keyboard."""
    try:
        print(f"\nAttempting to connect to {port} at {baudrate} baud...")
        ser = serial.Serial(port, baudrate, timeout=1)
        print("✓ Connection established!")
        
        print("\nSending test commands...")
        print("(Note: ZMK keyboards may not respond to serial commands)")
        
        # Try to read any output
        time.sleep(0.5)
        if ser.in_waiting:
            data = ser.read(ser.in_waiting)
            print(f"Received data: {data}")
        else:
            print("No data received (this is normal for ZMK)")
        
        ser.close()
        return True
        
    except serial.SerialException as e:
        print(f"✗ Connection failed: {e}")
        return False
    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        return False


def main():
    print("=" * 60)
    print("ZMK Keyboard Diagnostic Tool")
    print("=" * 60)
    print()
    
    keyboard_port = find_keyboard_port()
    
    if keyboard_port:
        print(f"\n{'=' * 60}")
        print("Testing connection...")
        print('=' * 60)
        test_connection(keyboard_port)
    else:
        print("\nNo obvious keyboard port detected.")
        print("If your keyboard is connected, it may be detected as a")
        print("standard HID device and not expose a serial interface.")
    
    print("\n" + "=" * 60)
    print("ZMK Configuration Notes:")
    print("=" * 60)
    print("""
ZMK keyboards typically:
- Do NOT expose a serial programming interface
- Configuration is compiled into firmware (.uf2 files)
- Must be flashed by copying .uf2 to bootloader USB drive
- Cannot extract configuration from running firmware

To modify your keyboard:
1. Edit the keymap in config/corne.keymap
2. Build the firmware (see README.md)
3. Flash by copying .uf2 files to the bootloader
    """)


if __name__ == "__main__":
    main()
