# This file explains all functions used in CODA

## Register images

### Global setup of functions

register_images:
- get_ims
  - find_tissue_area
- preprocessing
  - pad_im_both2
- calculate_global_reg
  - group_of_reg
    - reg_ims_com
      - calculate_transform
        - mskcircle2_rect
  - reg_ims_com
    - calculate_transform
      - mskcircle2_rect
- register_global_im
- calculate_elastic_registrationC
  - getImLocalWindowInd_rf
  - reg_ims_ELS
    - calculate_transform
      - mskcircle2_rect
  - make_final_grids
    - fill_vals

### function register_images(pth,IHC,E,zc,szz,sk,tpout,regE)
TODO: explanation.

Input:
- pth == path to all images (default = tif files)
- IHC == value of this determines the factor of reduce in calculate_global_reg and padding in preprocessing (default = 0)
  - IHC = empty||0||2||5 -> reduce = 6
  - IHC = 1 -> reduce = 4
  - IHC = 10 -> reduce = 2
  - IHC = empty||0||1||10 -> padding = mode
  - IHC = 2 -> padding = gray
  - IHC = 5 -> padding = black
- E == flag whether elastic registration is used (default = 1 -> elestic registration)
- zc == center image of the stack (default = ceil(len(imlist)/2))
- szz == max size of the images (default = found by loop)
- sk == skip value for selecting images along the z-axis (default = 1)
- tpout == type of output image (default = 'tif')
- regE == settings for elastic registration: size of registration tiles, buffer size, distance between tiles (default: 201, 100, 155)

### function [im,TA]=get_ims(pth,nm,tp,rdo)
Creates a 'pth\TA' directory and places tissue area in there (if it does not exist).

Input:
- pth == path to image
- nm == name of image
- tp == type of image
- rdo == flag for redoing the image reading (default = 0 -> no redo)

Output:
- im == image read
- TA == tissue area

### function [TA,fillval]=find_tissue_area(im0,nm)
Finds the tissue area based on subtracting a fill value from the image, applying filtering based on mean absolute differences, removing small and low-variation regions, and employing morphological operations to enhance and connect the identified tissue regions, ultimately yielding a binary tissue mask (finished with refining like black line removal).

Input:
- im0 == input image
- nm == name of image (default = '')

Output:
- TA == tissue area (binary mask over entire image)
- fillval == vector with color of background/non tissue

### function [im,impg,TA,fillval]=preprocessing(im,TA,szz,padall,IHC)
Preprocessing of image with padding, converting to gray image and adding gausfilter with sigma of 2. Image stays intact if IHC = 2||5, otherwise all the non-tissue will be white.

Input:
- im == image
- TA == tissue area (see find_tissue_area)
- szz == max size of images in stack (see register_images)
- padall == padding around all images (set to 250 in register_images)
- IHC == special value (see register_images)

Output:
- im == image in gray after preprocess steps
- impg == gray image after processing
- TA = tissue area (see find_tissue_area)
- fillval == background vector (see find_tissue_area)

### function im=pad_im_both2(im,sz,ext,fillval)
Adds the padding in the correct size of max size of image.

Input:
- im == image
- sz == szz (see register_images)
- ext == padall (see preprocessing)
- fillval == background vector (see find_tissue_area)

Output:
- im == image with padding

### function [imout,tform,cent,f,Rout]=calculate_global_reg(imrf,immv,rf,iternum,IHC,bb)
Calculates the global translation and rotation of the moving image based on reference image. 

Input:
- imrf == reference image
- immv == moving image
- rf == reduces images by \_ times
- iternum == number of iterations of registration code (set on 5 in register_images)
- bb == threshold for registration quality (default = 0.9)

Output:
- imout == output image after rotation and translation of immv
- tform == transformation matrix
- cent == centrum of transformation
- f == flag indicating if flip is performed (1 -> flipped)
- Rout == registration quality based on common pixels

### function [R,rs,xy,amv]=group_of_reg(amv0,arf,iternum0,sz,rf,bb)
First preprocesses the images with binary masks, converting to double precision and normalizing. Then uses reg_ims_com to find the transformation

Input:
- amv0 == resized immv wit 1/rf and gausfilter with std of 2 (see calculate_global_reg)
- arf == resized imrf wit 1/rf and gausfilter with std of 2 (see calculate_global_reg)
- iternum0 == number of iterations in reg_ims_com (set on 2 in calculate_global_reg)
- sz == size (set on [0,0] in calculate_global_reg)
- rf == reduce factor (see calculate_global_reg)
- bb == threshold for registration quality (default = 0.9)

Output:
- R == registration quality
- rs == rotation 
- xy == translation
- amv == registered immv

### function [tform,amv,rsft,xyt,RR]=reg_ims_com(amv0,arf,count,sz,rf,deg0,xy0,r,th)
Performs global registration by finding the center, using radon transforms and itterating to optimize paramters. This function calculates the preciese transformation matrix.

Input:
- amv0 == moving image (see group_of_reg)
- arf == reference frame (see group_of_reg)
- count == number of iteratations for global registration (set to 3)
- sz == maximum size of image (see register_images)
- rf == reduce factor (see calculate_global_reg)
- deg0 == initial rotation of image
- xy0 == initial translation of image
- r == flag for center of mass-based translation
- th == custom theta values for radon transformation (optional)

Output:

- tform == transformation matrix
- amv == transformed moving image
- rsft == total rotation angle
- xyt == total translation vector
- RR == cross correlation

### function res=calculate_transform(im,imnxt,xy,p)
estimate the dislocation of images between frames using particle image velocimetry.

Input:

- im == reference image
- imnxt == moving image
- xy == optional initial center coordinates
- p == paramters

Output: 

-res == displacement vector

### function msk=mskcircle2_rect(sz,da)
generate the circle mask based on size of input matrix

Input:
- sz == size of image
- da == diameter

Output:
- msk == mask over the image

### function imG=register_global_im(im,tform,cent,f,fillval)
Excecutes the needed tranformation

Input:

- im == image
- tform == transformation matrix
- cent == centre over which rotation should be
- f == flag wether image is flipped
- fillval == vector with color which is used for filling holes

Output:

- imG == new transformed image


### function [D,xgg,ygg,xx,yy]=calculate_elastic_registrationC(imrfR,immvR,TArf,TAmv,sz,bf,di,cutoff)

Input:

- imrfR == 
- immvR == 
- TArf == 
- TAmv == 
- sz ==
- bf ==
- di ==
- cutoff == 

Output:

- imG == new transformed image


TODO:

- calculate_elastic_registrationC
- getImLocalWindowInd_rf
- reg_ims_ELS
- make_final_grids
- fill_vals




