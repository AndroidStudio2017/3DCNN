% mReLU:    ReLU¼¤»îº¯Êý²ã
% 
function [ result ] = mReLU(input)
    result = BasicReLU;
    result.type = 'ReLU';
    result.input = input;
end