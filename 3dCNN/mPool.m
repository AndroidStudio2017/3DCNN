% mPool: �ػ���
%       input:      ����ά�� (height, width, frames)
%       ksize:      �ػ����ڱ߳�
%       strides:    ����
%       type:       �ػ����࣬Ŀǰ�ṩmax_pool��mean_pool
function [ layer ] = mPool(input, ksize, type)
    layer = BasicPool;
    layer.type = type;
    layer.input = input;
    layer.ksize = ksize;
end