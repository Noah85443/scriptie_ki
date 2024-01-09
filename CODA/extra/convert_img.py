import os
import pyvips
from tqdm.notebook import tqdm_notebook
import time


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

            print(f"{input_path} converted to {output_path}")

            try:
                thumb = pyvips.Image.thumbnail(input_path, 2048)
                thumb.write_to_file(output_path)

            except Exception as e:
                print(f"Error: {e}")


annotate_image("qptiff", "tif_scale_0.125", "qptiff", "tif", 8)
