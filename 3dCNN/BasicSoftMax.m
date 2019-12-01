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
            
            M = max(input(:));
            input = exp(input - M);
            allSum = sum(input(:));
            obj.res = input / allSum;
            r = obj.res;
        end
        
        function r = backward(obj, y)
            % yΪ����Ƶ����ʵ��ǩ
            r = obj.res - y;
        end
    end
end