% mPool: 池化层
%       ksize:      池化窗口边长
%       strides:    步长
%       type:       池化种类，目前提供max_pool和mean_pool
function [ layer ] = mPool(ksize, type)
    layer = BasicPool;
    layer.type = type;
    layer.ksize = ksize;
end