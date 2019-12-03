classdef BasicSoftMax < handle
    properties
        type            % ������
        input           % ����
        res             % �ò�ļ�����������BP
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Vector Dimension ERROR! %s\n', obj.type);
            end
            
            % ��ȡ�������ֵ����ԭsoftmax��ʽ���иı䣬��ֹ���
            M = max(input(:));
            input = exp(input - M);
            allSum = sum(input(:));
            
            % ����softmax
            obj.res = input / allSum;
            r = obj.res;
        end
        
        function r = backward(obj, y)
            % yΪ����Ƶ����ʵ��ǩ
            % ���㷴������
            r = obj.res - y;
        end
    end
end