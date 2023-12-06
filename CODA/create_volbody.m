function create_volbody(pthim, pthcoords, szz)

if exist([pthcoords, 'volbody.mat'], 'file'); return; end

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
vol=zeros(szz(1), szz(2), length(matlist));

disp(szz)
% register coordinates for each image
for kk=1:length(matlist)
    layer=zeros(szz(1), szz(2));
    % disp([pthcoords,matlist(kk).name])
    load([pthcoords,matlist(kk).name],'xy')
    indices = sub2ind([szz(1), szz(2)], xy(:, 1), xy(:, 2));
    layer(indices) = 1;
    vol(:,:,kk)=layer;
end

save([pthcoords,'volbody.mat'],'vol');