function alignment_metric(pth)
disp("Alignment Metric:")
newline;

pthR=[pth,'registered/'];
pthE=[pthR,'elastic registration/'];

imlist=dir([pth,'*.tif']);

% find pading for each type of image
szz=[0 0 3];
for kk=1:length(imlist)
    inf=imfinfo([pth,imlist(kk).name],'tif');
    szz=[max([szz(1),inf.Height]) max([szz(2),inf.Width]) 3]; 
end

szzR=[0 0 3];
for kk=1:length(imlist)
    inf=imfinfo([pthR,imlist(kk).name],'tif');
    szzR=[max([szz(1),inf.Height]) max([szz(2),inf.Width]) 3]; 
end

szzE=[0 0 3];
for kk=1:length(imlist)
    inf=imfinfo([pthE,imlist(kk).name],'tif');
    szzE=[max([szz(1),inf.Height]) max([szz(2),inf.Width]) 3]; 
end

simi=zeros([length(imlist)-1,1]);
simiR=simi;simiE=simi;
mse=simi;mseR=simi;mseE=simi;

immv1=imread([pth,imlist(1).name]);
image1=padarray(immv1, szz - size(immv1), 'post');
immv1=imread([pthR,imlist(1).name]);
image1R=padarray(immv1, szzR - size(immv1), 'post');
immv1=imread([pthE,imlist(1).name]);
image1E=padarray(immv1, szzE - size(immv1), 'post');


for kk=2:length(imlist)
    disp(['Image ' num2str(kk) ' of ' num2str(length(imlist))])
    immv1=imread([pth,imlist(kk).name]);
    image2=padarray(immv1, szz - size(immv1), 0, 'post');

    immv1=imread([pthR,imlist(kk).name]);
    image2R=padarray(immv1, szzR - size(immv1), 0, 'post');

    immv1=imread([pthE,imlist(kk).name]);
    image2E=padarray(immv1, szzE - size(immv1), 0, 'post');

    simi(kk-1)=ssim(image1, image2);
    simiR(kk-1)=ssim(image1R, image2R);
    simiE(kk-1)=ssim(image1E, image2E);
    mse(kk-1)=immse(image1, image2);
    mseR(kk-1)=immse(image1R, image2R);
    mseE(kk-1)=immse(image1E, image2E);

    if kk==length(imlist); continue; end
    image1=image2;image1R=image2R;image1E=image2E;

end

disp(['ssim image mean: ' num2str(mean(simi, 'all'))])
disp(['ssim registered mean: ' num2str(mean(simiR, 'all'))])
disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])
disp(['mse image mean: ' num2str(sqrt(mean(mse, 'all')))])
disp(['mse registered mean: ' num2str(sqrt(mean(mseR, 'all')))])
disp(['mse elastic mean: ' num2str(sqrt(mean(mseE, 'all')))])

figure('visible', 'off'), title(['Img, ssim: ' num2str(mean(simi, 'all')), 'rmse: ' num2str(sqrt(mean(mse, 'all')))]);
    subplot(1,3,1),imshow(image1),title('Image 1')
    subplot(1,3,2),imshow(image2),title('Image 2')
    subplot(1,3,3),imshowpair(image1,image2),title('Difference')
saveas(gcf, 'output_images/no_registration.png');

figure('visible', 'off'), title(['Reg, ssim: ' num2str(mean(simiR, 'all')), 'rmse: ' num2str(sqrt(mean(mseR, 'all')))]);
    subplot(1,3,1),imshow(image1R),title('Image 1')
    subplot(1,3,2),imshow(image2R),title('Image 2')
    subplot(1,3,3),imshowpair(image1R,image2R),title('Difference')
saveas(gcf, 'output_images/local_registration.png');

figure('visible', 'off'), title(['Els, ssim: ' num2str(mean(simiE, 'all')), 'rmse: ' num2str(sqrt(mean(mseE, 'all')))]);
    subplot(1,3,1),imshow(image1R),title('Image 1')
    subplot(1,3,2),imshow(image2R),title('Image 2')
    subplot(1,3,3),imshowpair(image1R,image2R),title('Difference')
saveas(gcf, 'output_images/global_registration.png');

end

% Convert images to double for normxcorr2
% image1 = im2double(image1);
% image2 = im2double(image2);
% 
% % Compute cross-correlation
% crossCorrelation = normxcorr2(image1, image2);
% 
% % Find the peak correlation coefficient and its location
% [maxCorr, maxIndex] = max(crossCorrelation(:));
% [yPeak, xPeak] = ind2sub(size(crossCorrelation), maxIndex);
% 
% % Display the peak correlation coefficient
% disp(['Peak Correlation Coefficient: ' num2str(maxCorr)]);
% 
% % Visualize the result
% figure;
% imshowpair(image1, image2, 'montage');
% title('Image Pair');
% 
% % Highlight the region of maximum correlation
% hold on;
% rectangle('Position', [xPeak-size(image1, 2)+1, yPeak-size(image1, 1)+1, size(image1, 2), size(image1, 1)], 'EdgeColor', 'r', 'LineWidth', 2);
% hold off;
