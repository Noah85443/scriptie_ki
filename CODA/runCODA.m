
pth = 'images';  % Replace with the actual path to your CODA folder
sk = 0;  % Set sk to the appropriate value

try
    % Call register_images with only pth and sk
    register_images(pth, [], [], [], [], sk);
catch err
    % Display the error message and stack trace
    disp('An error occurred:');
    disp(err.message);
    disp(['Error occurred on line ', num2str(err.stack(1).line), ' in ' err.stack(1).name]);
    disp(['Error occurred on line ', num2str(err.stack(2).line), ' in ' err.stack(2).name]);
    disp(['Error occurred on line ', num2str(err.stack(3).line), ' in ' err.stack(3).name]);
end