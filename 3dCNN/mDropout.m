% mDropout:     Dropout²ã 
%           p:              Dropout¸ÅÂÊ
function [ layer ] = mDropout(p)
    layer = BasicDropout;
    layer.p = p;
    layer.type = 'Dropout';
end