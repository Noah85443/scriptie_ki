function alignment_metric(pth)
disp(["Alignment Metric of",pth])
newline;

pthR=[pth,'registered/'];
% pthE=[pthR,'elastic registration/'];

imlist=dir([pthR,'*.tif']);

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

% szzE=[0 0 3];
% for kk=1:length(imlist)
%     inf=imfinfo([pthE,imlist(kk).name],'tif');
%     szzE=[max([szz(1),inf.Height]) max([szz(2),inf.Width]) 3]; 
% end

simi=[];
simiR=simi;%simiE=simi;
mse=simi;mseR=simi;%mseE=simi;
cross=simi; crossR=simi;%crossE=simi;
coss=simi;cosR=simi;%cosE=simi;

immv1=imread([pth,imlist(1).name]);
image1=padarray(immv1, szz - size(immv1), 'post');

immv1=imread([pthR,imlist(1).name]);
image1R=padarray(immv1, szzR - size(immv1), 'post');

% immv1=imread([pthE,imlist(1).name]);
% image1E=padarray(immv1, szzE - size(immv1), 'post');

image1g = rgb2gray(image1);
image1Rg = rgb2gray(image1R);
% image1Eg = rgb2gray(image1E);
% imshow(image1g);
for kk=2:length(imlist)
    disp(['Image ' num2str(kk) ' of ' num2str(length(imlist))])
    immv1=imread([pth,imlist(kk).name]);
    image2=padarray(immv1, szz - size(immv1), 0, 'post');

    immv1=imread([pthR,imlist(kk).name]);
    image2R=padarray(immv1, szzR - size(immv1), 0, 'post');

    % immv1=imread([pthE,imlist(kk).name]);
    % image2E=padarray(immv1, szzE - size(immv1), 0, 'post');

    image2g = rgb2gray(image2);
    image2Rg = rgb2gray(image2R);
    % image2Eg = rgb2gray(image2E);

    simi = [simi, ssim(image1, image2)];
    simiR = [simiR, ssim(image1R, image2R)];
    % simiE(kk-1)=ssim(image1E, image2E);
 
    mse = [mse, immse(image1, image2)];
    mseR = [mseR, immse(image1R, image2R)];
    % mseE(kk-1)=immse(image1E, image2E);

    cross = [cross, sum(sum(image1g-image2g))/(255*szz(1)*szz(2))];
    crossR = [crossR, sum(sum(image1Rg-image2Rg))/(255*szzR(1)*szzR(2))];
    % crossE = [crossE, xcorr(image1Eg, image2Eg)];

    
    coss = [coss, dot(double(image1g(:)), double(image2g(:))) / (norm(double(image1g(:))) * norm(double(image2g(:))));];
    cosR = [cosR, dot(double(image1Rg(:)), double(image2Rg(:))) / (norm(double(image1Rg(:))) * norm(double(image2Rg(:))));];
    % cosE = [cosE, dot(double(image1Eg(:)), double(image2Eg(:))) / (norm(double(image1Eg(:))) * norm(double(image2Eg(:))));];

    % cos = [cos, sum(sum(image1g .* image2g))/(sqrt(sum(sum(image1g.^2)))*sqrt(sum(sum(image2g.^2))))];
    % cosR = [cosR, sum(sum(image1Rg .* image2Rg))/(sqrt(sum(sum(image1Rg.^2)))*sqrt(sum(sum(image2Rg.^2))))];
    % cosE = [cosE, sum(sum(image1Eg .* image2Eg))/(sqrt(sum(sum(image1Eg.^2)))*sqrt(sum(sum(image2Eg.^2))))];

    if kk==length(imlist); continue; end
    image1=image2;image1R=image2R;%image1E=image2E;
    image1g=image2g;image1Rg=image2Rg;%image1Eg=image2Eg;

    disp(['ssim image mean: ' num2str(mean(simi, 'all'))])
    disp(['ssim registered mean: ' num2str(mean(simiR, 'all'))])
    % disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])

    disp(['mse image mean: ' num2str(sqrt(mean(mse, 'all')))])
    disp(['mse registered mean: ' num2str(sqrt(mean(mseR, 'all')))])
    % disp(['mse elastic mean: ' num2str(sqrt(mean(mseE, 'all')))])

    disp(['cross image mean: ' num2str(mean(cross, 'all'))])
    disp(['cross registered mean: ' num2str(mean(crossR, 'all'))])
    % disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])    

    disp(['cos image mean: ' num2str(mean(coss, 'all'))])
    disp(['cos registered mean: ' num2str(mean(cosR, 'all'))])
    % disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])    
end

disp(['ssim image mean: ' num2str(mean(simi, 'all'))])
disp(['ssim registered mean: ' num2str(mean(simiR, 'all'))])
% disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])

disp(['mse image mean: ' num2str(sqrt(mean(mse, 'all')))])
disp(['mse registered mean: ' num2str(sqrt(mean(mseR, 'all')))])
% disp(['mse elastic mean: ' num2str(sqrt(mean(mseE, 'all')))])

disp(['cross image mean: ' num2str(mean(cross, 'all'))])
disp(['cross registered mean: ' num2str(mean(crossR, 'all'))])
% disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])  

disp(['cos image mean: ' num2str(mean(coss, 'all'))])
disp(['cos registered mean: ' num2str(mean(cosR, 'all'))])
% disp(['ssim elastic mean: ' num2str(mean(simiE, 'all'))])   

% figure('visible', 'off'), title(['Img, ssim: ' num2str(mean(simi, 'all')), 'rmse: ' num2str(sqrt(mean(mse, 'all')))]);
%     subplot(1,3,1),imshow(image1),title('Image 1')
%     subplot(1,3,2),imshow(image2),title('Image 2')
%     subplot(1,3,3),imshowpair(image1,image2),title('Difference')
% saveas(gcf, 'output_images/no_registration.png');

% figure('visible', 'off'), title(['Reg, ssim: ' num2str(mean(simiR, 'all')), 'rmse: ' num2str(sqrt(mean(mseR, 'all')))]);
%     subplot(1,3,1),imshow(image1R),title('Image 1')
%     subplot(1,3,2),imshow(image2R),title('Image 2')
%     subplot(1,3,3),imshowpair(image1R,image2R),title('Difference')
% saveas(gcf, 'output_images/local_registration.png');

% figure('visible', 'off'), title(['Els, ssim: ' num2str(mean(simiE, 'all')), 'rmse: ' num2str(sqrt(mean(mseE, 'all')))]);
%     subplot(1,3,1),imshow(image1R),title('Image 1')
%     subplot(1,3,2),imshow(image2R),title('Image 2')
%     subplot(1,3,3),imshowpair(image1R,image2R),title('Difference')
% saveas(gcf, 'output_images/global_registration.png');

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
