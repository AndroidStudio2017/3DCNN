% mDropout:     Dropout�� 
%           p:              Dropout����
function [ layer ] = mDropout(p)
    layer = BasicDropout;
    layer.p = p;
    layer.type = 'Dropout';
end