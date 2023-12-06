% create volbody
vol=zeros(4, 4, 4);
xylist = {[[1,1]; [2,2]; [3,3]; [4,4]],
          [[1,4]; [2,3]; [3,2]; [4,1]],
          [[2,1]; [2,2]; [2,3]; [2,4]],
          [[1,1]; [2,1]; [3,1]; [4,1]]};

% display the first set of coordinates
disp(xylist{2});

% register coordinates for each image
for kk=1:4
    disp(kk)
    layer=zeros(4, 4);
    xy=xylist{kk};
    indices = sub2ind([4, 4], xy(:, 1), xy(:, 2));
    layer(indices) = 1;
    vol(:,:,kk)=layer;
end

disp(vol);
% save([pthcoords,'volbody.mat'],'vol');