function additionalRotation = logpolar(amv, arf)
    % Convert angle range to radians
    angleRange = deg2rad(-5:0.1:5);

    % Define polar grid
    [rows, cols] = size(amv);
    maxRadius = floor(min(rows, cols) / 2);
    numAngles = length(angleRange);

    % Initialize variables for best rotation
    bestRotation = 0;
    bestCorrelation = -inf;

    % Generate log-polar images
    logPolarRef = zeros(maxRadius, numAngles);
    logPolarMov = zeros(maxRadius, numAngles);

    for r = 1:maxRadius
        for a = 1:numAngles
            angle = angleRange(a);
            x = round(r * cos(angle)) + cols / 2;
            y = round(r * sin(angle)) + rows / 2;

            % Check if coordinates are within image bounds
            if x >= 1 && x <= cols && y >= 1 && y <= rows
                logPolarRef(r, a) = arf(y, x);
                logPolarMov(r, a) = amv(y, x);
            end
        end
    end

    % Calculate optimal rotation using log-polar transformation
    for i = 1:length(angleRange)
        shifted = circshift(logPolarMov, [0, i-1]);
        correlation = sum(sum(logPolarRef .* shifted));

        if correlation > bestCorrelation
            bestCorrelation = correlation;
            bestRotation = angleRange(i);
        end
    end

    % Convert optimal rotation to rotation matrix
    theta = -bestRotation; % Negative because the rotation is applied in the opposite direction
    additionalRotation = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1];
end
% 
% function rotationMatrix = logpolar(amv, arf)
%     % Log-polar transformation
%     logPolarRef = logpolar(arf);
%     logPolarMov = logpolar(amv);
% 
%     % Calculate additional rotation using log-polar transformation
%     [rows, cols] = size(logPolarRef);
%     shift = round(rows / 4);
%     correlation = zeros(1, shift * 2 + 1);
% 
%     for i = -shift:shift
%         shifted = circshift(logPolarMov, [i, 0]);
%         correlation(i + shift + 1) = sum(sum(logPolarRef .* shifted));
%     end
% 
%     [~, idx] = max(correlation);
%     rotation = idx - shift - 1;
% 
%     theta = deg2rad(rotation);
%     rotationMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
% end
