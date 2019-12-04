% ReLU�������
classdef BasicReLU < handle
    properties
        type            % ������
        input           % ����ά��
        inputData       % �����������BP
    end
    methods
        function r = forward(obj, input)
            % ��������ά��
            obj.input = size(input);
            
            obj.inputData = input;
            % ReLU����
            % ReLU(x)
            % ��x>0ʱ��ReLU(x) = x
            % ��x<=0ʱ��ReLU(x) = 0
            r = input .* (input > 0);
        end
        function r = backward(obj, dj)
            % ReLU�����ķ��򴫲�
            % ��Ϊ�������Щֵ�����û�й��ף����Խ���������Щδ�����
            r = dj .* (obj.inputData > 0);
        end
    end
end