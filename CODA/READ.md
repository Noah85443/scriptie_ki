# This file explains all functions used in CODA

## Register images

### Global setup of functions

register_images:

- get_ims
  - find_tissue_area
- preprocessing
  - pad_im_both2
- register_global_im
- calculate_global_reg
  - group_of_reg
    - reg_ims_com
      - calculate_transform
        - mskcircle2_rect
  - reg_ims_com
    - calculate_transform
      - mskcircle2_rect
- calculate_elastic_registrationC
  - getImLocalWindowInd_rf
  - reg_ims_ELS
    - calculate_transform
      - mskcircle2_rect
  - make_final_grids
    - fill_vals

### function register_images(pth,IHC,E,zc,szz,sk,tpout,regE)

- pth == path to images
- IHC == value of this determines the factor of reduce in calculate_global_reg and padding in preprocessing (default = 0)
  - IHC = empty||0||2||5 -> reduce = 6
  - IHC = 1 -> reduce = 4
  - IHC = 10 -> reduce = 2
  - IHC = empty||0||1||10 -> padding = mode
  - IHC = 2 -> padding = gray
  - IHC = 5 -> padding = black
- E: (default = 1)

### function [imout,tform,cent,f,Rout]=calculate_global_reg(imrf,immv,rf,iternum,IHC,bb)

This function calculates the global translation and rotation of the immv based on imrf

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

### function [im,impg,TA,fillval]=preprocessing(im,TA,szz,padall,IHC)

Preprocessing of image with padding, converting to gray image and adding gausfilter with sigma of 2

- im == image
- TA == tissue area (will initialy by created by get_ims and find_tissue_area under 'path\TA\')
- szz == max size of images in stack
- padall

### function [im,TA]=get_ims(pth,nm,tp,rdo)

Retrieves image and TA (tissue area of image) based on path

-

### function [TA,fillval]=find_tissue_area(im0,nm)
