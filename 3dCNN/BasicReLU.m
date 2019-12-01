% ReLU�������
classdef BasicReLU < handle
    properties
        type            % ������
        input           % ����ά��
        inputData       % �����������BP
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Vector Dimension ERROR! %s\n', obj.type);
            end
            
            obj.inputData = input;
            r = input .* (input > 0);
        end
        function r = backward(obj, dj)
            r = dj .* (obj.inputData > 0);
        end
    end
end