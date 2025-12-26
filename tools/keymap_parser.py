#!/usr/bin/env python3
"""
ZMK Keymap Parser and Validator

This script parses and validates ZMK keymap files.
"""

import re
import sys
from pathlib import Path


class KeymapParser:
    """Parse ZMK keymap files."""
    
    def __init__(self, keymap_path):
        self.keymap_path = Path(keymap_path)
        self.content = ""
        self.layers = {}
        
    def read_file(self):
        """Read the keymap file."""
        with open(self.keymap_path, 'r') as f:
            self.content = f.read()
    
    def extract_layers(self):
        """Extract layer definitions from the keymap."""
        # Find all layer blocks
        layer_pattern = r'(\w+_layer)\s*\{[^}]*?bindings\s*=\s*<([^>]+)>;'
        matches = re.finditer(layer_pattern, self.content, re.DOTALL)
        
        for match in matches:
            layer_name = match.group(1)
            bindings = match.group(2)
            
            # Clean up the bindings
            bindings = re.sub(r'//[^\n]*', '', bindings)  # Remove comments
            bindings = re.sub(r'/\*.*?\*/', '', bindings, flags=re.DOTALL)  # Remove block comments
            
            # Extract key bindings
            keys = []
            for line in bindings.split('\n'):
                line = line.strip()
                if line:
                    keys.extend(line.split())
            
            self.layers[layer_name] = keys
    
    def validate_keymap(self):
        """Validate the keymap structure."""
        issues = []
        
        for layer_name, keys in self.layers.items():
            # Check for Corne standard layout (42 keys: 3x6 + 3 per side)
            if len(keys) != 42:
                issues.append(f"{layer_name}: Expected 42 keys, found {len(keys)}")
            
            # Check for common typos or issues
            for i, key in enumerate(keys):
                if not key.startswith('&'):
                    issues.append(f"{layer_name} position {i}: Invalid binding '{key}' (should start with &)")
        
        return issues
    
    def print_layout(self):
        """Print a visual representation of the layout."""
        for layer_name, keys in self.layers.items():
            print(f"\n{layer_name.replace('_', ' ').title()}")
            print("=" * 80)
            
            if len(keys) >= 42:
                # Print in Corne layout format (3 rows of 6, then 3 thumb keys per side)
                print("\nLeft Half:                                  Right Half:")
                print("-" * 80)
                
                # Top row (keys 0-5 left, 6-11 right)
                left = ' '.join(f"{k:12s}" for k in keys[0:6])
                right = ' '.join(f"{k:12s}" for k in keys[6:12])
                print(f"{left}    {right}")
                
                # Middle row (keys 12-17 left, 18-23 right)
                left = ' '.join(f"{k:12s}" for k in keys[12:18])
                right = ' '.join(f"{k:12s}" for k in keys[18:24])
                print(f"{left}    {right}")
                
                # Bottom row (keys 24-29 left, 30-35 right)
                left = ' '.join(f"{k:12s}" for k in keys[24:30])
                right = ' '.join(f"{k:12s}" for k in keys[30:36])
                print(f"{left}    {right}")
                
                # Thumb keys (keys 36-38 left, 39-41 right)
                print("\nThumb Keys:")
                left = ' '.join(f"{k:12s}" for k in keys[36:39])
                right = ' '.join(f"{k:12s}" for k in keys[39:42])
                print(f"            {left}    {right}")
            else:
                print(f"Warning: Unexpected number of keys ({len(keys)})")
                print(keys)


def main():
    if len(sys.argv) < 2:
        print("Usage: python keymap_parser.py <path_to_keymap>")
        sys.exit(1)
    
    keymap_path = sys.argv[1]
    
    print("=" * 80)
    print("ZMK Keymap Parser and Validator")
    print("=" * 80)
    
    parser = KeymapParser(keymap_path)
    
    try:
        parser.read_file()
        parser.extract_layers()
        
        print(f"\nFound {len(parser.layers)} layer(s):")
        for layer_name in parser.layers.keys():
            print(f"  - {layer_name}")
        
        # Validate
        issues = parser.validate_keymap()
        
        if issues:
            print("\n⚠️  Validation Issues Found:")
            for issue in issues:
                print(f"  - {issue}")
        else:
            print("\n✓ Keymap validation passed!")
        
        # Print visual layout
        parser.print_layout()
        
    except FileNotFoundError:
        print(f"Error: File not found: {keymap_path}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
