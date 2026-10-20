from PIL import Image

def resize_image(input_path, output_path, size):
    image = Image.open(input_path)
    resized_image = image.resize(size)
    resized_image.save(output_path)
    print(f'Image resized and saved to {output_path}')

resize_image('path/to/input/image.jpg', 'path/to/output/image.jpg', (800, 600))
