% separateRGB:  ���ڽ�RGB������ͨ������
%       image:  RGBͼ�� (height, width, channels)
function [R, G, B] = separateRGB(image)
    R = image(:, :, 1);
    G = image(:, :, 2);
    B = image(:, :, 3);
end