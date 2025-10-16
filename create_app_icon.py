#!/usr/bin/env python3

from PIL import Image, ImageDraw, ImageFont
import os

def create_insurance_app_icon():
    # Create the main icon (1024x1024)
    size = 1024
    image = Image.new('RGB', (size, size), color='#FFFFFF')
    draw = ImageDraw.Draw(image)
    
    # Background gradient effect (simulated with circles)
    center = size // 2
    
    # Pink gradient background
    for i in range(20):
        alpha = int(255 * (1 - i/20) * 0.1)
        color = f'#{255:02x}{int(0 + i*5):02x}{int(131 + i*3):02x}{alpha:02x}'
        radius = size//2 - i*10
        if radius > 0:
            bbox = [center-radius, center-radius, center+radius, center+radius]
            try:
                draw.ellipse(bbox, fill=color)
            except:
                pass
    
    # Main shield shape
    shield_points = [
        (center, size//6),  # Top center
        (center + size//4, size//4),  # Top right
        (center + size//4, center),   # Middle right
        (center, size*5//6),          # Bottom point
        (center - size//4, center),   # Middle left
        (center - size//4, size//4),  # Top left
    ]
    
    draw.polygon(shield_points, fill='#FF0083')
    
    # Inner shield highlight
    inner_shield = [
        (center, size//6 + 30),
        (center + size//4 - 30, size//4 + 20),
        (center + size//4 - 30, center - 20),
        (center, size*5//6 - 40),
        (center - size//4 + 30, center - 20),
        (center - size//4 + 30, size//4 + 20),
    ]
    draw.polygon(inner_shield, fill='#FF4DA6')
    
    # Checkmark symbol
    # Calculate checkmark points
    check_size = size // 8
    check_center_x = center
    check_center_y = center - 50
    
    # Checkmark path
    check_points = [
        (check_center_x - check_size//2, check_center_y),
        (check_center_x - check_size//4, check_center_y + check_size//3),
        (check_center_x + check_size//2, check_center_y - check_size//3)
    ]
    
    # Draw thick checkmark
    for offset in range(-8, 9):
        offset_points = [(x + offset, y) for x, y in check_points]
        draw.polygon(offset_points, fill='#FFFFFF')
    
    # Save main icon
    icon_dir = "/Users/bradleysimpson/Demo Insurance/Resources/Icons"
    os.makedirs(icon_dir, exist_ok=True)
    
    # Save 1024x1024 version
    image.save(f"{icon_dir}/AppIcon-1024.png", "PNG")
    
    # Generate all required iOS icon sizes
    sizes = [20, 29, 40, 58, 60, 76, 80, 87, 114, 120, 152, 167, 180, 1024]
    
    for icon_size in sizes:
        resized = image.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
        resized.save(f"{icon_dir}/AppIcon-{icon_size}.png", "PNG")
    
    print("✅ App icons generated successfully!")
    print(f"📁 Icons saved in: {icon_dir}")
    
    # Create App Icon set structure
    iconset_dir = f"{icon_dir}/AppIcon.appiconset"
    os.makedirs(iconset_dir, exist_ok=True)
    
    # Copy icons to iconset with proper naming
    icon_mappings = [
        ("AppIcon-40.png", "Icon-App-20x20@2x.png"),
        ("AppIcon-60.png", "Icon-App-20x20@3x.png"),
        ("AppIcon-58.png", "Icon-App-29x29@2x.png"),
        ("AppIcon-87.png", "Icon-App-29x29@3x.png"),
        ("AppIcon-80.png", "Icon-App-40x40@2x.png"),
        ("AppIcon-120.png", "Icon-App-40x40@3x.png"),
        ("AppIcon-120.png", "Icon-App-60x60@2x.png"),
        ("AppIcon-180.png", "Icon-App-60x60@3x.png"),
        ("AppIcon-152.png", "Icon-App-76x76@2x.png"),
        ("AppIcon-167.png", "Icon-App-83.5x83.5@2x.png"),
        ("AppIcon-1024.png", "Icon-App-1024x1024@1x.png")
    ]
    
    for source, target in icon_mappings:
        source_path = f"{icon_dir}/{source}"
        target_path = f"{iconset_dir}/{target}"
        if os.path.exists(source_path):
            import shutil
            shutil.copy2(source_path, target_path)

if __name__ == "__main__":
    create_insurance_app_icon()