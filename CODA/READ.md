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
This function calculates the global translation and rotation of the moving image based on reference image. 

Input:

- imrf == reference image
- immv == moving image
- rf == reduce images by \_ times
- iternum == number of iterations of registration code (set on 5 in register_images)
- bb == registration quality (default = 0.9)

Output:

- imout == output image after rotation and translation of immv
- tform == transformation matrix
- cent == centrum of transformation
- f == flag indicating if flip is performed (1 -> flipped)
- Rout == registration quality based on common pixels

### function [tform,amv,rsft,xyt,RR]=reg_ims_com(amv0,arf,count,sz,rf,deg0,xy0,r,th)
TODO

Input:
- amv0 ==
- arf ==
- count ==
- sz ==
- rf ==
- deg0 ==
- xy0 ==
- r ==
- th ==

Output:
- tform ==
- amv ==
- rsft ==
- xyt==
- RR ==
- 
### function res=calculate_transform(im,imnxt,xy,p)
TODO

Input:
- im ==
- imnxt ==
- xy ==
- p ==

Output: 
-res ==

### function msk=mskcircle2_rect(sz,da)
TODO

Input:
- sz ==
- da ==

Output:
- msk == 

### function imG=register_global_im(im,tform,cent,f,fillval)
TODO: 

Input:

- im == image
- tform == 
- cent == 
- f ==
- fillval == 

Output:

- imG ==

TODO:

- calculate_elastic_registrationC
- getImLocalWindowInd_rf
- reg_ims_ELS
- make_final_grids
- fill_vals




