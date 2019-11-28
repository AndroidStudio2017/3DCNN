% mPool: 池化层
%       input:      输入维度 (height, width, frames)
%       ksize:      池化窗口边长
%       strides:    步长
%       type:       池化种类，目前提供max_pool和mean_pool
function [ layer ] = mPool(input, ksize, type)
    layer = BasicPool;
    layer.type = type;
    layer.input = input;
    layer.ksize = ksize;
end