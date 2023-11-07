import tifffile
import matplotlib.pyplot as plt

with tifffile.TiffFile("H21-066.1_HE331_0005_Scan1.qptiff") as tif:
    image = tif.asarray()

plt.imshow(image)
plt.show()
