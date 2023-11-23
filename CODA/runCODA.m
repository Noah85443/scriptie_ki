pth = '/images';  % Replace with the actual path to your CODA folder
IHC = 0;  % Set IHC to the appropriate value
E = 1;  % Set E to the appropriate value
zc = 10;  % Set zc to the appropriate value
szz = [height, width];  % Set szz to the size of your images
sk = 1;  % Set sk to the appropriate value
tpout = 'tif';  % Set tpout to the appropriate value
regE.szE = 201;  % Set regE.szE to the appropriate value
regE.bfE = 100;  % Set regE.bfE to the appropriate value
regE.diE = 155;  % Set regE.diE to the appropriate value

register_images(pth, IHC, E, zc, szz, sk, tpout, regE);
