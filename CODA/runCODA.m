% Convert qptiff to tif
s = 0.125;
ip = 'qptiff/';
op = ['tif_scale_', num2str(s), '/'];
it = 'qptiff';
ot = 'tif';

pyrunfile("convert_img.py", inpth=ip, outpth=op, intyp=it, outtyp=ot, scale=s)

pth = op;
pthcoords = [pth, 'cell_coords/'];
IHC=0;
E=1;
zs=[];
szz=[];
sk=1;
regE=[];
scale=0.99;
try
    % HE_cell_count(pth);

    register_images(pth, IHC, E, zs, szz, sk, ot, regE);

    register_cell_coordinates(pth,pthcoords,scale);

catch err

    % Display the error message and stack trace
    disp('An error occurred:');
    disp(err.message);
    disp(['Error occurred on line ', num2str(err.stack(1).line), ' in ' err.stack(1).name]);
    % disp(['Error occurred on line ', num2str(err.stack(2).line), ' in ' err.stack(2).name]);
    % disp(['Error occurred on line ', num2str(err.stack(3).line), ' in ' err.stack(3).name]);
    % disp(['Error occurred on line ', num2str(err.stack(4).line), ' in ' err.stack(4).name]);
    % disp(['Error occurred on line ', num2str(err.stack(5).line), ' in ' err.stack(5).name]);
end