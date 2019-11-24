function [ layer ] = mSoftMax(input)
    layer = BasicSoftMax;
    layer.input = zeros(input(1), input(2), input(3));
    layer.type = 'SoftMax';
end