
pth = 'images_tif_down16/';
IHC=0;
E=1;
zs=[];
szz=[];
sk=1;
tpout='tif';
regE=[];
try
    % Call register_images with only pth and sk
    register_images(pth, IHC, E, zs, szz, sk, tpout, regE);
catch err
    % Display the error message and stack trace
    disp('An error occurred:');
    disp(err.message);
    disp(['Error occurred on line ', num2str(err.stack(1).line), ' in ' err.stack(1).name]);
    disp(['Error occurred on line ', num2str(err.stack(2).line), ' in ' err.stack(2).name]);
    disp(['Error occurred on line ', num2str(err.stack(3).line), ' in ' err.stack(3).name]);
    disp(['Error occurred on line ', num2str(err.stack(4).line), ' in ' err.stack(4).name]);
    % disp(['Error occurred on line ', num2str(err.stack(5).line), ' in ' err.stack(5).name]);
end

%% DOWNSAMPLING IN MATLAB
% downsampled = 'images_tif_down\';
% mkdir(downsampled);
% 
% imlist = dir([pth, '*.tif']);
% 
% for kk = 1:length(imlist)
%     originalImage = imread(fullfile(pth, imlist(kk).name));
%     downsampledImage = imresize(originalImage, 1/16);
%     fullFilePath = fullfile(downsampled, ['down_', imlist(kk).name]);
%     imwrite(downsampledImage, fullFilePath, 'tif');
% end
% 
% pth = downsampled;