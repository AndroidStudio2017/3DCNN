classdef BasicSoftMax < handle
    properties
        type            % 层类型
        input           % 输入
        res             % 该层的计算结果，用于BP
    end
    methods
        function r = forward(obj, input)
            % 保存输入维度
            obj.input = size(input);
            
            % 求取整个最大值，对原softmax公式进行改变，防止溢出
            M = max(input(:));
            input = exp(input - M);
            allSum = sum(input(:));
            
            % 计算softmax
            obj.res = input / allSum;
            r = obj.res;
        end
        
        function r = backward(obj, y)
            % y为该视频的真实标签
            % 计算反馈导数
            r = obj.res - y;
        end
    end
end