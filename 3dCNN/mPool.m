% mPool: �ػ���
%       ksize:      �ػ����ڱ߳�
%       strides:    ����
%       type:       �ػ����࣬Ŀǰ�ṩmax_pool��mean_pool
function [ layer ] = mPool(ksize, type)
    layer = BasicPool;
    layer.type = type;
    layer.ksize = ksize;
end