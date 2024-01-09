function find_pink(pth)
disp("Find Pink:")
newline;
outpth=[pth,'coords_pink/'];
if ~exist(outpth, 'dir'); mkdir(outpth);end

imlist=dir([pth,'*.tif']);
for kk=1:length(imlist)
    
    imnm=imlist(kk).name;
    disp(['Image ' num2str(kk) ' of ' num2str(length(imlist))])
    if exist([outpth,imnm(1:end-3),'mat'],'file');continue;end
    img=imread([pth, imlist(kk).name]);

    xy = [];
    for i = 1:size(img, 1)
        for j = 1:size(img, 2)
            if img(i, j, 1) > 230 && img(i, j, 2) > 100 && img(i, j, 2) < 220 && img(i, j, 3) > 180 && img(i, j, 3) < 240
                xy = [xy; [i, j]]; 
            end
        end
    end
    save([outpth,imnm(1:end-3),'mat'],'xy');
end
