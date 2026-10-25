"""Build compact overview images from the original emulator screenshots.

Usage: python3 -m pip install Pillow && python3 tool/make_gallery.py
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / 'docs/screenshots'
FONT = ROOT / 'assets/fonts/Montserrat.ttf'
SCREENS = [
    ('01-splash', 'Welcome'), ('02-login', 'Login'), ('03-signup', 'Sign up'),
    ('04-editorial', 'Collection'), ('05-discover', 'Discover'), ('06-menu', 'Menu'),
    ('07-category', 'Category'), ('08-filters', 'Filters'), ('09-product', 'Product'),
    ('10-reviews', 'Reviews'), ('11-cart-empty', 'Empty cart'), ('12-cart', 'Cart'),
    ('13-shipping', 'Shipping'), ('14-payment', 'Payment'), ('15-done', 'Order complete'),
    ('16-search', 'Search'), ('17-search-results', 'Search results'),
    ('18-wishlist', 'Wishlist'), ('19-map', 'Find us'), ('20-scan', 'Scan'),
    ('21-account', 'Account'), ('22-settings', 'Settings'),
]


def gallery(items, columns, width, output):
    thumb_h = round(width * 2436 / 1125)
    gap, label_h = 18, 38
    rows = (len(items) + columns - 1) // columns
    canvas = Image.new('RGB', (columns * (width + gap) + gap,
                              rows * (thumb_h + label_h + gap) + gap), '#e9edeb')
    draw = ImageDraw.Draw(canvas)
    font = ImageFont.truetype(str(FONT), 15)
    font.set_variation_by_axes([500])
    for i, (name, title) in enumerate(items):
        image = Image.open(SHOTS / f'{name}.png').convert('RGB')
        image.thumbnail((width, thumb_h), Image.Resampling.LANCZOS)
        x = gap + (i % columns) * (width + gap)
        y = gap + (i // columns) * (thumb_h + label_h + gap)
        draw.text((x, y + 8), f'{name[:2]}  {title}', fill='#222222', font=font)
        canvas.paste(image, (x, y + label_h))
    canvas.save(SHOTS / output, quality=90, optimize=True)


if __name__ == '__main__':
    gallery(SCREENS, 6, 200, '00-overview.jpg')
    chosen = {'05-discover', '07-category', '09-product', '12-cart', '13-shipping', '21-account'}
    gallery([item for item in SCREENS if item[0] in chosen], 3, 280, '00-key-screens.jpg')
