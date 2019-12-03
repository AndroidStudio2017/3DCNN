function [ layer ] = mConv3d(input, filter, strides, learning_rate)
    layer = BasicConv3d;
    layer.type = 'Conv3d';
    layer.input = input;
    layer.filter = filter;
    layer.strides = strides;
    layer.learning_rate = learning_rate;
end