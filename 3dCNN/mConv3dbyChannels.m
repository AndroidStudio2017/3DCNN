% mConv3d:  用于构建一个3维卷积层
%       filter:     卷积核 (height, width, frames, fm)
%       strides:    步长 (height, width, frames)，表示各个方向移动的步长
%           
function [ layer ] = mConv3dbyChannels(filter, strides, learning_rate)
    layer = BasicConv3dbyChannels;
    layer.type = 'Conv3d';
    layer.filter = filter;
    layer.strides = strides;
    layer.learning_rate = learning_rate;
end