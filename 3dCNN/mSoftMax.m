function [ layer ] = mSoftMax(input)
    layer = BasicSoftMax;
    layer.input = input;
    layer.type = 'SoftMax';
end