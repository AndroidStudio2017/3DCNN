% mReLU:    ReLU�������
% 
function [ result ] = mReLU(input)
    result = BasicReLU;
    result.type = 'ReLU';
    result.input = input;
end