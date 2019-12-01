classdef BasicDropout < handle
    properties
        type            % ������
        input           % ����ά��
        p               % dropout����
        random          % ��¼ǰ��ʱ���������Щ��Ԫ������BP
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            % ����dropout
            obj.random = rand(size(input));
            input(obj.random <= obj.p) = -1;         % �ó�-1�ټ���ReLU��������0
            r = input / (1 - obj.p);            % ����������Ԫ��������
        end
        function r = backward(obj, dj)
            temp = obj.random > obj.p;
            gradientDrop = dj .* (temp / (1 - obj.p));
            r = gradientDrop;
        end
    end
end