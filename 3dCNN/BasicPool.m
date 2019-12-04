classdef BasicPool < handle
    properties
        type            % �ػ����࣬max_pool��mean_pool
        input           % ����ά��
        ksize           % �ػ����ڱ߳�
        indexRow        % ��Ϊmax_pool����¼ȡ�����ֵ����λ��
        indexCol        %                ��¼ȡ�����ֵ����λ��
    end
    methods
        function r = forward(obj, input)
            % ��¼input size
            obj.input = size(input);
            
            % �ػ�������mPooling����
            % mPooling����������������������
            %   input       ���ػ�����
            %   ksize       �ػ������С
            %   type        �ػ�����(max, mean)
            % ����ֵ��
            %   r           �ػ����
            %   indexRow    ����������˵��ѡ������ֵ��λ�õ�������
            %   indexCol    ����������˵��ѡ������ֵ��λ�õ�������
            [r, obj.indexRow, obj.indexCol] = mPooling(input, obj.ksize, obj.type);
        end
        % �ػ����򴫲�
        function r = backward(obj, dj)
            % ���ȶ���ػ����򴫲�֮�����
            % ��С�ͳػ��������һ�£�����гػ�����Ĳ��֣���Ϊ����ѵ������˵
            % ʶ��Ĺ�����û��Ӱ�죬����ֱ������
            r = zeros(obj.input);
            
            [H, W, F] = size(dj);
            for i=1:F
                for j=1:H
                    for k=1:W
                        % ��������أ�
                        % 1.ͨ��indexRow��indexColȥ��ԭ��ȡ�����ֵ��λ��
                        % 2.�ָ�
                        % �����ƽ���أ�
                        % 1.�Ƚ��������Գػ���Ĵ�С�����ƽ��ֵ
                        % 2.�ҵ�ԭ���ĳػ��飬��ƽ��ֵ�������
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