% mConv3d:  ���ڹ���һ��3ά�����
%       filter:     ����� (height, width, frames, fm)
%       strides:    ���� (height, width, frames)����ʾ���������ƶ��Ĳ���
%           
function [ layer ] = mConv3dbyChannels(filter, strides, learning_rate)
    layer = BasicConv3dbyChannels;
    layer.type = 'Conv3d';
    layer.filter = filter;
    layer.strides = strides;
    layer.learning_rate = learning_rate;
end