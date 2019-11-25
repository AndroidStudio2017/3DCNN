classdef BasicSoftMax
    properties
        type            % 层类型
        input           % 输入
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Vector Dimension ERROR! %s\n', obj.type);
            end
            
            allSum = sum(input(:));
            r = input / allSum;
        end
        
        function r = backward(obj, dj)
            
        end
    end
end