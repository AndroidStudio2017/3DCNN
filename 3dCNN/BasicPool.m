classdef BasicPool
    properties
        type            % �ػ����࣬max_pool��mean_pool
        input           % ����
        ksize           % �ػ����ڱ߳�
        strides         % ������һ��ѡ����ksizeһ��
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            
        end
        function r = backward(obj, dj)
            
        end
    end
end