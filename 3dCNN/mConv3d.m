% mConv3d:  ���ڹ���һ��3ά�����
%       input:         ���� (height, width, frames) (ɾ�����õȵ������ʱ�����input)
%       filter:     ����� (height, width, frames, fm)
%       strides:    ���� (height, width, frames)����ʾ���������ƶ��Ĳ���
%           
function [ layer ] = mConv3d(input, filter, strides)
    layer = BasicConv3d;
    layer.input = input;
    layer.type = 'Conv3d';
    layer.filter = filter;
    layer.strides = strides;
end