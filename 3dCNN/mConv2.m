% mConv2:   ��matlab�Դ��Ķ�ά���������չ������strides
%       mat:        �����
%       filter:     �����
%       strides:    �������
%       padding:    ����߽緽ʽ��'sample'��'valid'��'full'
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