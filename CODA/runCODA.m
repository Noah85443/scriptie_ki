addpath("base/")
pth='tif_down16/';
pthr='tif_down16/registered/';
pthcoords='tif_down16/cell_coords/';
pthcoordsreg='tif_down16/registered/elastic registration/cell_coordinates_registered/';
IHC=0;
E=1;
zs=[];
szz=[];
sk=1;
regE=[];
scale=0.99;
try
    % HE_cell_count(pth);
    % register_images(pth,IHC,E,zs,szz,sk,'tif',regE);
    % register_cell_coordinates(pth,pthcoords,scale);
    % create_volbody(pth, pthcoords, szz);
    plot_3D_tiss(pth,pthcoords,szz,[0 0 1],4,20)

catch err

    % Display the error message and stack trace
    disp('An error occurred:');
    disp(err.message);
    disp(['Error occurred on line ', num2str(err.stack(1).line), ' in ' err.stack(1).name]);
    disp(['Error occurred on line ', num2str(err.stack(2).line), ' in ' err.stack(2).name]);
    % disp(['Error occurred on line ', num2str(err.stack(3).line), ' in ' err.stack(3).name]);
    % disp(['Error occurred on line ', num2str(err.stack(4).line), ' in ' err.stack(4).name]);
    % disp(['Error occurred on line ', num2str(err.stack(5).line), ' in ' err.stack(5).name]);
end

% % Convert qptiff to tif
% s = 0.125;
% ip = 'qptiff/';
% op = ['tif_scale_', num2str(s), '/'];
% it = 'qptiff';
% ot = 'tif';
% pth = op;
% pthcoords = [pth, 'cell_coords/'];

% pyrunfile("convert_img.py", inåååpth=ip, outpth=op, intyp=it, outtyp=ot, scale=s)