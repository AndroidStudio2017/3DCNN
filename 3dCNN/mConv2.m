% mConv2:   对matlab自带的二维卷积进行扩展，加入strides
%       mat:        大矩阵
%       filter:     卷积核
%       strides:    卷积步长
%       padding:    处理边界方式，'sample'、'valid'、'full'
function [ result ] = mConv2(mat, filter, strides, padding)
    %% Debug
    size(mat);
    size(filter);
    
    %% main code
    result = conv2(double(mat), double(filter), padding);
    
    [M, N] = size(result);
    result = result(1:strides(1):M, 1:strides(2):N);
    
    size(result);
end