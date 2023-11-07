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
  - Area specific alignment:
    - Create multi point grid over target and origin image
    - Create cost function for overlay with warped image
    - Optimze the cost function using gradient descent, Gauss-Newton or Levenberg-Marquardt (keep regularization in mind)
  - Cell detection based on nuclear coordinates
    - The use of the pretrained ResNet50 (we can do our own network or stardist
  - Create 3D images based on coordinates

- Automatic Lymphocyte Detection in H&E Images with Deep Neural Networks: H&E cell detection using DNN (MatConvNet in matlab)
  - Used an FCN to detect the cells in H&E stains (Mask R-CNN?)
    - It is an u shaped structure with and encoder-decoder frame
    - Convolutions are used between layers

- Cell Detection with Star-convex Polygons: base method of recognizing cells
  - Instead of square boxes uses a polygon with a center to determin de oddly shaped cells
  - Introduction of Stardist which has pre trained models and is better preforming than U-net and R-cnn
  
- 3D reconstruction of multiple stained histology images: 3D image based on H&E images (stacking the different images
  - 3 proposed methods: stack the different stacks separately and merge them, start with one image and keep stacking on this and do it pair wise
  - The second strategy has the best result
  
- Integration of 3D multimodal imaging data of a head and neck cancer and advanced feature recognition: 3D image based on H&E images
  - Coarse alignment: start with a rotation and translation matrix for intial shift
    - After that minimize the function J = D + S where D is the NGF distance term and S an regulizer which controols smoothness of deformation
    - Regulizer: $S = \frac{\alpha}{2} \int_{\Omega} \mu <\nabla y, \nabla y> + (\lambda + \mu) (\nabla \cdot y)^2$
    - Use MALDI spots for further orientation
   
- Optimization and enhancement of H&E stained microscopical images by applying bilinear interpolation method on lab color mode
  - Enhancing the quality of imaging in order to beter detect using bilinear interpolation 

FAIR: flexible algorithms for image registration:
- TODO: READ

Possible stacking images for ai:
- Use ai to recognize crucial points on which it can be stacked (if distance between images is not to big)
- Use SIFT and transformation matrix to calculate transformations and possibly wrapping of imaging (same concern here)
- Edge detection and 

https://www.grammarly.com/
