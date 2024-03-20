% Include all the meaningfull functions
addpath("3D_functions/")    
addpath("detection_functions/")
addpath("registration_functions/")  
addpath("segmentation_functions/")  
addpath("extra/")  

% Vars for register_images (which is same for HE_cell_count)
pth='patient/';  % pth to images which need to be registered
IHC=0;              % factor for reduce and padding (see documentation)
E=0;                % flag whether elastic registration is used
zs=[];              % center image of the stack
szz=[];             % max size of the images
sk=1;               % skip value for selecting images
tpout='tif';        % type of output file
regE=[];            % settings for elastic registration (see documentation)

% Vars for deeplearning
pthtrain='deeplearning/';                                   % path to training data
pthim=[pth,'registered/elastic registration/'];             % path to images for classify
umpix=1;                                                    % um/pixel: 1=10x, 2=5x, 4=16x
nm='outputfile';                                            % name of output
classNames=["Normal" "Fat" "Bloodvessel" "Stroma" "black"]; % names of annotated classes

% Vars for 3D image
pthcoords=[pth, 'cell_coords/'];                            % path to coordinates
rgb=[0 0 1];                                                % rgb color of object
xyres=4;                                                    % xy resolution (um/pixel)
zres=20;                                                    % z resolution (um/pixel)

% Save all the images
if ~exist('output_images/', 'dir'); mkdir('output_images/');end

try
    % registering images
    % register_images(pth,IHC,E,zs,szz,sk,tpout,regE);
    % alignment_metric(pth)
    % HE_cell_count([pth, 'registered/'])

    % training and segmenting with deeplearning
    % make_training_deeplab(pthtrain, pthtrain, umpix, nm, classNames)

    % % Creating 3D plot
    body = create_volbody(pth,pthcoords,szz);
    plot_3D_tiss(body,rgb,xyres,zres)
 
    % % Cell peaks as example 
    % HE_cell_count(pth);
    % register_cell_coordinates(pth,pthcoords,scale);

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