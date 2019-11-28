classdef BasicPool < handle
    properties
        type            % 池化种类，max_pool和mean_pool
        input           % 输入
        ksize           % 池化窗口边长
        indexRow        % 若为max_pool，记录取得最大值的行位置
        indexCol        %                记录取得最大值的列位置
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
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