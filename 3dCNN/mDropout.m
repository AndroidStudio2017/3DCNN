% mDropout:     Dropout�� 
%           input:          ����ά��
%           p:              Dropout����
function [ layer ] = mDropout(input, p)
    layer = BasicDropout;
    layer.input = input;
    layer.p = p;
    layer.type = 'Dropout';
end