path = 'patient_log/';
pathC = 'images_tif_down16/cell_coords/';
pthG = 'images_tif_down16/registered/';
pthL = 'images_tif_down16/registered/elastic registration/';
imgname = 'D16_H21-066.1_HE331_0049_Scan1.tif';
coordname = 'D16_H21-066.1_HE331_0049_Scan1.mat';

imgg='patient_log/TA/H21-066.4_HE332_001_Scan1.qptiff - resolution #1.tif';
imgg = imread(imgg);
disp(imgg);

% imgtest='Images4096/registered/test0.tif';
% imgred=imread(imgtest, 'tif');
% imshow(imgred);
% exit;

img = imread([pth, imgname]);
imgg = imread([pthG, imgname]);
imgl = imread([pthL, imgname]);
xy = load([pathC, coordname], 'xy');

% Check if the structure contains a field named 'xy'
% if ~isfield(data, 'xy')
%     error('Failed to find field ''xy'' in the MAT file.');
% end
% 
% % Access the xy field
% xy = data(1);

% Check if xy is empty or has the expected size
if isempty(xy) || ~isequal(size(xy), [1133, 2])
    error('Failed to load valid xy coordinates from the MAT file.');
end
% if size(img, 3) > 1
%     img = rgb2gray(img);
% end
% 
% if size(imgg, 3) > 1
%     imgg = rgb2gray(imgg);
% end
% 
% if size(imgl, 3) > 1
%     imgl = rgb2gray(imgl);
% end
% 
% corg = corr2(img, imgg);
% corl = corr2(img, imgl);
% 
% disp(corg, corl);

% imshowpair(imread([pth, img]), imread([pthG, img]));

% figure;
% imshow(255 - img);  % Display the inverted image
% axis equal;
% hold on;
% plot(xy(:,1), xy(:,2), 'ro');

figure(17);
    subplot(1,3,1),imshow(img),title('original')
    subplot(1,3,2),imshow(imgg),title('global')
    subplot(1,3,3),imshow(imgl),title('local')
    ha=get(gcf,'children');linkaxes(ha);