#!/usr/bin/env python3
"""
AirWord 图标一键替换脚本

使用方法:
1. 将 1024x1024 的 PNG 图标放入 assets/icons/ 目录，命名为 icon.png
2. 运行: python3 assets/update_icons.py
"""

import os
import sys
from pathlib import Path
from PIL import Image

# 项目根目录
ROOT_DIR = Path(__file__).parent.parent
ASSETS_DIR = ROOT_DIR / "assets" / "icons"

# 图标配置
ICONS_CONFIG = {
    "app": {
        "android": {
            "base_path": ROOT_DIR / "app" / "android" / "app" / "src" / "main" / "res",
            "sizes": {
                "mipmap-mdpi": (48, 48),
                "mipmap-hdpi": (72, 72),
                "mipmap-xhdpi": (96, 96),
                "mipmap-xxhdpi": (144, 144),
                "mipmap-xxxhdpi": (192, 192),
            }
        },
        "ios": {
            "base_path": ROOT_DIR / "app" / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset",
            "sizes": {
                "Icon-App-20x20@1x.png": (20, 20),
                "Icon-App-20x20@2x.png": (40, 40),
                "Icon-App-20x20@3x.png": (60, 60),
                "Icon-App-29x29@1x.png": (29, 29),
                "Icon-App-29x29@2x.png": (58, 58),
                "Icon-App-29x29@3x.png": (87, 87),
                "Icon-App-40x40@1x.png": (40, 40),
                "Icon-App-40x40@2x.png": (80, 80),
                "Icon-App-40x40@3x.png": (120, 120),
                "Icon-App-60x60@2x.png": (120, 120),
                "Icon-App-60x60@3x.png": (180, 180),
                "Icon-App-76x76@1x.png": (76, 76),
                "Icon-App-76x76@2x.png": (152, 152),
                "Icon-App-83.5x83.5@2x.png": (167, 167),
                "Icon-App-1024x1024@1x.png": (1024, 1024),
            }
        }
    },
    "desktop": {
        "base_path": ROOT_DIR / "desktop" / "build",
        "sizes": {
            "icon.png": (1024, 1024),  # 源文件复制
        }
    },
    "web": {
        "base_path": ROOT_DIR / "web" / "public",
        "sizes": {
            "favicon-16x16.png": (16, 16),
            "favicon-32x32.png": (32, 32),
            "apple-touch-icon.png": (180, 180),
            "android-chrome-192x192.png": (192, 192),
            "android-chrome-512x512.png": (512, 512),
        }
    }
}


def resize_image(input_path: Path, output_path: Path, size: tuple, rounded=False, remove_alpha=False):
    """调整图片尺寸并保存

    Args:
        remove_alpha: 是否移除alpha通道（iOS App Store图标需要）
    """
    with Image.open(input_path) as img:
        # 转换为 RGBA 模式
        if img.mode != 'RGBA':
            img = img.convert('RGBA')

        # 创建透明背景
        resized = img.resize(size, Image.Resampling.LANCZOS)

        if rounded and size[0] == size[1] and size[0] >= 48:
            # 创建圆角遮罩（仅用于较大的正方形图标）
            mask = Image.new('L', size, 0)
            from PIL import ImageDraw
            draw = ImageDraw.Draw(mask)
            radius = size[0] // 5  # 圆角半径
            draw.rounded_rectangle((0, 0, size[0], size[1]), radius, fill=255)

            output = Image.new('RGBA', size, (0, 0, 0, 0))
            output.paste(resized, (0, 0), mask)
            resized = output

        # iOS App Store图标不能包含alpha通道
        if remove_alpha:
            # 创建白色背景
            background = Image.new('RGB', size, (255, 255, 255))
            # 将RGBA图标粘贴到白色背景上（使用alpha作为mask）
            if resized.mode == 'RGBA':
                background.paste(resized, mask=resized.split()[-1])  # 使用alpha通道作为mask
            else:
                background.paste(resized)
            resized = background

        # 保存为 PNG
        if output_path.suffix == '.png':
            resized.save(output_path, 'PNG')
        else:
            resized.save(output_path)

        print(f"  ✓ {output_path.name} ({size[0]}x{size[1]}){' (无透明)' if remove_alpha else ''}")


def generate_android_icons(source_image: Path):
    """生成 Android 图标"""
    print("\n📱 生成 Android 图标...")
    config = ICONS_CONFIG["app"]["android"]

    for folder, size in config["sizes"].items():
        output_dir = config["base_path"] / folder
        output_dir.mkdir(parents=True, exist_ok=True)
        output_path = output_dir / "ic_launcher.png"
        resize_image(source_image, output_path, size)


def generate_ios_icons(source_image: Path):
    """生成 iOS 图标"""
    print("\n🍎 生成 iOS 图标...")
    config = ICONS_CONFIG["app"]["ios"]
    config["base_path"].mkdir(parents=True, exist_ok=True)

    for filename, size in config["sizes"].items():
        output_path = config["base_path"] / filename
        # iOS App Store 1024x1024 图标不能包含alpha通道
        remove_alpha = (size == (1024, 1024))
        resize_image(source_image, output_path, size, remove_alpha=remove_alpha)

    # 更新 Contents.json
    contents_json = '''{
  "images" : [
    {
      "filename" : "Icon-App-20x20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-20x20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-29x29@1x.png",
      "idiom" : "iphone",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-29x29@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-29x29@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-40x40@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-40x40@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-60x60@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "Icon-App-60x60@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "Icon-App-20x20@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-20x20@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-App-29x29@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-29x29@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "Icon-App-40x40@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-40x40@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "Icon-App-76x76@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "filename" : "Icon-App-76x76@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "Icon-App-83.5x83.5@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "Icon-App-1024x1024@1x.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}'''
    (config["base_path"] / "Contents.json").write_text(contents_json)
    print("  ✓ Contents.json")


def generate_desktop_icons(source_image: Path):
    """生成 Desktop 图标"""
    print("\n💻 生成 Desktop 图标...")
    config = ICONS_CONFIG["desktop"]
    config["base_path"].mkdir(parents=True, exist_ok=True)

    # 复制源文件
    output_path = config["base_path"] / "icon.png"
    import shutil
    shutil.copy(source_image, output_path)
    print(f"  ✓ icon.png (1024x1024)")

    # 生成 .icns (macOS)
    try:
        import subprocess
        temp_dir = config["base_path"] / "icon.iconset"
        temp_dir.mkdir(exist_ok=True)

        # 生成各种尺寸
        sizes = [16, 32, 64, 128, 256, 512, 1024]
        for size in sizes:
            with Image.open(source_image) as img:
                resized = img.resize((size, size), Image.Resampling.LANCZOS)
                resized.save(temp_dir / f"icon_{size}x{size}.png", 'PNG')
                if size <= 512:
                    resized2x = img.resize((size * 2, size * 2), Image.Resampling.LANCZOS)
                    resized2x.save(temp_dir / f"icon_{size}x{size}@2x.png", 'PNG')

        # 使用 iconutil 创建 icns 文件
        result = subprocess.run(
            ["iconutil", "-c", "icns", str(temp_dir), "-o", str(config["base_path"] / "icon.icns")],
            capture_output=True,
            text=True
        )

        # 清理临时文件
        import shutil
        shutil.rmtree(temp_dir)

        if result.returncode == 0:
            print("  ✓ icon.icns (macOS)")
        else:
            print(f"  ⚠ icon.icns 生成失败 (仅在 macOS 上可用)")
    except Exception as e:
        print(f"  ⚠ icon.icns 生成失败: {e}")

    # 生成 .ico (Windows)
    try:
        with Image.open(source_image) as img:
            # ICO 文件需要多尺寸
            sizes_ico = [(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
            imgs = []
            for size in sizes_ico:
                resized = img.resize(size, Image.Resampling.LANCZOS)
                if resized.mode != 'RGBA':
                    resized = resized.convert('RGBA')
                imgs.append(resized)

            imgs[0].save(
                config["base_path"] / "icon.ico",
                format='ICO',
                sizes=sizes_ico,
                append_images=imgs[1:]
            )
            print("  ✓ icon.ico (Windows)")
    except Exception as e:
        print(f"  ⚠ icon.ico 生成失败: {e}")

    # 生成 Linux 图标 (多尺寸 PNG)
    try:
        icons_dir = config["base_path"] / "icons"
        icons_dir.mkdir(exist_ok=True)

        linux_sizes = [16, 32, 48, 64, 128, 256, 512, 1024]
        for size in linux_sizes:
            with Image.open(source_image) as img:
                resized = img.resize((size, size), Image.Resampling.LANCZOS)
                resized.save(icons_dir / f"{size}x{size}.png", 'PNG')
        print(f"  ✓ icons/ ({len(linux_sizes)} sizes for Linux)")
    except Exception as e:
        print(f"  ⚠ Linux 图标生成失败: {e}")


def generate_web_icons(source_image: Path):
    """生成 Web 图标"""
    print("\n🌐 生成 Web 图标...")
    config = ICONS_CONFIG["web"]
    config["base_path"].mkdir(parents=True, exist_ok=True)

    for filename, size in config["sizes"].items():
        output_path = config["base_path"] / filename
        resize_image(source_image, output_path, size)

    # 生成 favicon.ico (多尺寸)
    try:
        with Image.open(source_image) as img:
            sizes_ico = [(16, 16), (32, 32), (48, 48)]
            imgs = []
            for size in sizes_ico:
                resized = img.resize(size, Image.Resampling.LANCZOS)
                if resized.mode != 'RGBA':
                    resized = resized.convert('RGBA')
                imgs.append(resized)

            imgs[0].save(
                config["base_path"] / "favicon.ico",
                format='ICO',
                sizes=sizes_ico,
                append_images=imgs[1:]
            )
            print("  ✓ favicon.ico")
    except Exception as e:
        print(f"  ⚠ favicon.ico 生成失败: {e}")


def main():
    """主函数"""
    print("=" * 50)
    print("🎨 AirWord 图标一键替换工具")
    print("=" * 50)

    # 检查源文件
    source_image = ASSETS_DIR / "icon.png"

    if not source_image.exists():
        print(f"\n❌ 错误: 未找到源图标文件")
        print(f"   请将 1024x1024 的 PNG 图标放入:")
        print(f"   {source_image}")
        print(f"\n   建议图标规格:")
        print(f"   - 尺寸: 1024x1024 像素")
        print(f"   - 格式: PNG")
        print(f"   - 背景: 透明或纯色")
        sys.exit(1)

    # 验证源文件
    with Image.open(source_image) as img:
        width, height = img.size
        if width != 1024 or height != 1024:
            print(f"\n⚠️  警告: 源图标尺寸为 {width}x{height}，建议 1024x1024")
        else:
            print(f"\n📄 源图标: {source_image} ({width}x{height})")

    # 生成各端图标
    generate_android_icons(source_image)
    generate_ios_icons(source_image)
    generate_desktop_icons(source_image)
    generate_web_icons(source_image)

    print("\n" + "=" * 50)
    print("✅ 图标替换完成!")
    print("=" * 50)
    print("\n注意:")
    print("  - App: 需要重新构建应用才能看到新图标")
    print("  - Desktop: 需要重新打包才能看到新图标")
    print("  - Web: 刷新页面即可看到新图标")
    print()


if __name__ == "__main__":
    main()
