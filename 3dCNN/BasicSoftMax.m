classdef BasicSoftMax < handle
    properties
        type            % 层类型
        input           % 输入
        res             % 该层的计算结果，用于BP
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
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
            % y为该视频的真实标签
            r = obj.res - y;
        end
    end
end