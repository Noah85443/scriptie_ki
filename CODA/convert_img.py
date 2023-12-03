from PIL import Image
import os


def annotate_image(inpth, outpth, intyp, outtyp, scale):
    # Create the output folder if it doesn't exist
    if not os.path.exists(outpth):
        os.makedirs(outpth)

    # Loop over the images in the input folder
    for filename in os.listdir(inpth):
        print(filename)
        if filename.endswith(intyp):
            input_path = os.path.join(inpth, filename)
            output_path = os.path.join(outpth, filename.replace(intyp, outtyp))

            try:
                # Open the Qtiff file
                with Image.open(input_path) as img:
                    # Calculate the new size based on the scale factor
                    new_size = (int(img.width * scale), int(img.height * scale))

                    # Resize the image
                    resized_img = img.resize(new_size, Image.ANTIALIAS)

                    # Save the downsized image in TIFF format
                    resized_img.save(output_path, format="TIF")

                print(f"Downsampling successful: {input_path} -> {output_path}")

            except Exception as e:
                print(f"Error: {e}")


annotate_image("qptiff", "tif_scale_0.125", "qptiff", "tif", 0.125)
