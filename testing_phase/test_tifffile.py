import imageio
import matplotlib.pyplot as plt

# Replace 'your_file.qptiff' with the path to your QPTiff file
qptiff_data = imageio.imread("H21-066.4_HE332_105_Scan1.qptiff")

# Display the image using matplotlib
plt.imshow(qptiff_data, cmap="gray")  # You can adjust the colormap as needed
plt.title("QPTiff Image")
plt.colorbar()  # Add a colorbar for reference if necessary
plt.show()
