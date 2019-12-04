function [ layer ] = mConv3d(filter, strides, learning_rate)
    layer = BasicConv3d;
    layer.type = 'Conv3d';
    layer.filter = filter;
    layer.strides = strides;
    layer.learning_rate = learning_rate;
end