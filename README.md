# Explore the Future of Medical Imaging: Ultrasound and Photoacoustic Image Fusion
In this reposetory is my bachelor thesis for artificial intelligence.

Stardist: an importable library which has pretrained models to detect cells using star shape polygons. You can also train it yourself.
Matlab: envoirement excellent for plotting 3d images.

Refrences for report: https://practicumav.nl/schrijven/refereren.html

Articles of interest: 
- https://en.wikipedia.org/wiki/H%26E_stain: what is H&E imaging
  - Biopt taken and stianed with gematoxylin and eosin
  - Nuclei visible in purplish blue
  - Cytoplasm and extracellular matrix pink
- CODA: quantitative 3D reconstruction of large tissues at cellular resolution: 3D reconstruction of pancreas
  - Coarse alignment: using rigid-body registration where translation and rotation matrix are found by Radon transform with cross correlation
    - Possible different method: Log polar transform (Features based image registration using cross correlation and Radon transform)
  - Image registration:
    - Create multi point grid over target and origin image
    - Create cost function for overlay with warped image
    - Optimze the cost function using gradient descent, Gauss-Newton or Levenberg-Marquardt (keep regularization in mind)
- Automatic Lymphocyte Detection in H&E Images with Deep Neural Networks: H&E cell detection using DNN
-
- Cell Detection with Star-convex Polygons: base method of recognizing cells
- 3D reconstruction of multiple stained histology images: 3D image based on H&E images
- Integration of 3D multimodal imaging data of a head and neck cancer and advanced feature recognition: 3D image based on H&E images



Possible stacking images for ai:
- Use ai to recognize crucial points on which it can be stacked (if distance between images is not to big)
- Use SIFT and transformation matrix to calculate transformations and possibly wrapping of imaging (same concern here)
