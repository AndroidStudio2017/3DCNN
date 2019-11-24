% separateRGB:  用于将RGB的三个通道分离
%       image:  RGB图像 (height, width, channels)
function [R, G, B] = separateRGB(image)
    R = image(:, :, 1);
    G = image(:, :, 2);
    B = image(:, :, 3);
end