classdef BasicPool < handle
    properties
        type            % �ػ����࣬max_pool��mean_pool
        input           % ����
        ksize           % �ػ����ڱ߳�
        indexRow        % ��Ϊmax_pool����¼ȡ�����ֵ����λ��
        indexCol        %                ��¼ȡ�����ֵ����λ��
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            [r, obj.indexRow, obj.indexCol] = mPooling(input, obj.ksize, obj.type);
        end
        function r = backward(obj, dj)
            r = zeros(obj.input);
            
            [H, W, F] = size(dj);
            for i=1:F
                for j=1:H
                    for k=1:W
                        if strcmp(obj.type, 'max_pool')
                            r(obj.indexRow(j, k, i), obj.indexCol(j, k, i), i)          ...
                            = dj(j, k, i);
                        elseif strcmp(obj.type, 'mean_pool')
                            value = dj(j, k, i) / (obj.ksize * obj.ksize);
                            left_up = [(j-1)*obj.ksize(1) + 1, (k-1)*obj.ksize(2) + 1];
                            r(left_up(1):left_up(1)+obj.ksize(1)-1,       ...
                            left_up(2):left_up(2)+obj.ksize(2)-1, i) = value;
                        else
                            error('[ERROR] Arguments ERROR! Pooling Back');
                        end
                    end
                end
            end
        end
    end
end