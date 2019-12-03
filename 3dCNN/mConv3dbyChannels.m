% mConv3d:  用于构建一个3维卷积层
%       input:         输入 (height, width, frames) (删除，得等到计算的时候才有input)
%       filter:     卷积核 (height, width, frames, fm)
%       strides:    步长 (height, width, frames)，表示各个方向移动的步长
%           
function [ layer ] = mConv3dbyChannels(input, filter, strides, learning_rate)
    layer = BasicConv3dbyChannels;
    layer.input = input;
    layer.type = 'Conv3d';
    layer.filter = filter;
    layer.strides = strides;
    layer.learning_rate = learning_rate;
end