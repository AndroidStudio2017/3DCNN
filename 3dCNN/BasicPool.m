classdef BasicPool < handle
    properties
        type            % 池化种类，max_pool和mean_pool
        input           % 输入维度
        ksize           % 池化窗口边长
        indexRow        % 若为max_pool，记录取得最大值的行位置
        indexCol        %                记录取得最大值的列位置
    end
    methods
        function r = forward(obj, input)
            % 记录input size
            obj.input = size(input);
            
            % 池化，调用mPooling函数
            % mPooling函数的输入是三个参数：
            %   input       待池化矩阵
            %   ksize       池化矩阵大小
            %   type        池化类型(max, mean)
            % 返回值：
            %   r           池化结果
            %   indexRow    对于最大池来说，选择的最大值的位置的行坐标
            %   indexCol    对于最大池来说，选择的最大值的位置的列坐标
            [r, obj.indexRow, obj.indexCol] = mPooling(input, obj.ksize, obj.type);
        end
        % 池化反向传播
        function r = backward(obj, dj)
            % 首先定义池化反向传播之后矩阵
            % 大小和池化层的输入一致，如果有池化多余的部分，因为其在训练或者说
            % 识别的过程中没有影响，所以直接置零
            r = zeros(obj.input);
            
            [H, W, F] = size(dj);
            for i=1:F
                for j=1:H
                    for k=1:W
                        % 如果是最大池：
                        % 1.通过indexRow和indexCol去找原来取得最大值的位置
                        % 2.恢复
                        % 如果是平均池：
                        % 1.先将该数除以池化块的大小，获得平均值
                        % 2.找到原来的池化块，用平均值进行填充
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