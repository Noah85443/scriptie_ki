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
Takes the middle image of the stack. Based on this images in rotates the rest of the stack globally and locally to fit best on the middle images creating a stack of tuned images. Creates registered folder with globaly warped images. Within this a folder elastic registration with saves the localy warped images. Within this a folder save_waprs which contains the transformation information globally. Within this a folder D which contains the transformation information locally. Within this a folder Dnew which contains recalculated tranformation (optional and by default empty). Follow the structure of the functions in order to get idea of how the function works.

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
Excecutes the needed tranformation.

Input:

- im == image
- tform == transformation matrix
- cent == centre over which rotation should be
- f == flag wether image is flipped
- fillval == vector with color which is used for filling holes

Output:

- imG == new transformed image


### function [D,xgg,ygg,xx,yy]=calculate_elastic_registrationC(imrfR,immvR,TArf,TAmv,sz,bf,di,cutoff)
Calculates the local displacement by slicing the image into different tiles and warps them.

Input:

- imrfR == reference image
- immvR == moving image
- TArf == tissue area reference image
- TAmv == tissue area moving image
- sz == registration tiles size (element of regE in register_images which is set at 201)
- bf == size of buiffer on registration tiles (element of regE in register_images which is set at 100)
- di == distance between tiles (element of regE in register_images which is set at 155)
- cutoff == threshold for tissue percentage (set at 0.15)

Output:

- D == displacement map
- xgg ==
- ygg ==
- xx ==
- yy == 

### function ind=getImLocalWindowInd_rf(xy,imsz,wndra,skipstep)
Generating indices matrices representing local windows around centroid locations in an image.

Input:

- xy == n by 2 vectors of centroid location
- imsz == 1 by 2 vector of image size 
- wndra == local window size
- skipstep == scalar of vector indicating the stepsize for sampling points within the local window

Output:

- ind == n by wndra*2+1 indices matrices where each row represent the local windows

### function [X,Y,imout,RR]=reg_ims_ELS(amv0,arf0,rf,v)
performing elastic registration on small tiles of immvR to imrfR by calculating the displacement between the tiles. The key steps include image resizing, transformation calculation, and storing displacement values in grids.

Input:

- amv0 == moving image
- arf0 == reference image
- rf == resize factor
- v == flag indicating if the transformation of tile should be calculated (set to 0)

Output:

- X == displacement in the x direction
- Y == displacement in the y direction
- imout == transformed tile (optional output based on v)
- RR == cross correlation of transformed tile (optional output based on v)

### function [D,xgg,ygg,x,y]=make_final_grids(xgg0,ygg0,bf,x,y,szim)
Creates displacement map that is smooth and continuous, addressing issues such as large translations and missing values.

Input:

- xgg0 == initial displacement along x-axis
- ygg0 == initial displacement along y-axis
- bf == buffer size around the image (see register_images)
- x == point on image along x-axis that xgg0 is centered at
- y == point on image along y-axis that ygg0 is centered at
- szim == size of image

Output:

- D == final displacement map
- xgg == processed displacement grid along the x-axis.
- ygg == processed displacement grid along the y-axis.
- x == point on image along x-axis that xgg is centered at
- y == point on image along y-axis that ygg is centered at


### function [xgg,ygg,dxgg,dygg,denom,sxgg,sygg]=fill_vals(xgg,ygg,cc,xystd)
Fills in non-continuous values in the displacement map (x and y) with the mean of their neighbors.
