function volbody=create_volbody(pthim, pthcoords, szz)
disp("Creating volbody based on: ")
disp(pthim)

imlist=dir([pthim,'TA/', '*tif']);
% matlist=dir([pthcoords,'*mat']); 

% find max size of images in list
if ~exist('szz','var') || isempty(szz)
    szz=[0 0];
    for kk=1:length(imlist)
        inf=size(imread([pthim,'TA/',imlist(kk).name]));
        szz=[max([szz(1),inf(1)]) max([szz(2),inf(2)])]; 
    end
end
% create volbody
volbody=zeros(szz(1)/10, szz(2)/10, length(imlist));

% register coordinates for each image
for kk=1:length(imlist)
    disp(['Layer: ', num2str(kk), ' of ', num2str(length(imlist)-1)])
    ta_img=imread([pthim,'TA/',imlist(kk).name]);
    ta_img = imresize(ta_img,[szz(1)/10, szz(2)/10]);
    % %pinidisp(['Img: ', imlist(kk).name])
    % layer=zeros(szz(1), szz(2));
    % load([pthcoords,matlist(kk).name],'xy')
    % indices = sub2ind([szz(1), szz(2)], round(xy(:, 1)), round(xy(:, 2)));
    % layer(indices) = 1;
    volbody(:,:,kk)=mat2gray(ta_img);
end
% figure;imshow(mat2gray(volbody), []);title('z-projection of all structures');
end