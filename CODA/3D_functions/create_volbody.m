function volbody=create_volbody(pthim, pthcoords, szz)
disp("Creating volbody based on: ")
disp(pthcoords)

imlist=dir([pthim, '*tif']);
matlist=dir([pthcoords,'*mat']);

% find max size of images in list
if ~exist('szz','var') || isempty(szz)
    szz=[0 0];
    for kk=1:length(imlist)
        inf=imfinfo(imlist(kk).name,'tif');
        szz=[max([szz(1),inf.Width]) max([szz(2),inf.Height])]; 
    end
end

% create volbody
volbody=zeros(szz(1), szz(2), length(matlist));

% register coordinates for each image
for kk=1:length(matlist)-1
    disp(['Layer: ', num2str(kk), ' of ', num2str(length(matlist)-1)])
    %pinidisp(['Img: ', imlist(kk).name])
    layer=zeros(szz(1), szz(2));
    load([pthcoords,matlist(kk).name],'xy')
    indices = sub2ind([szz(1), szz(2)], round(xy(:, 1)), round(xy(:, 2)));
    layer(indices) = 1;
    volbody(:,:,kk)=layer;
end
end