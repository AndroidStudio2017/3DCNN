% ReLU激活函数层
classdef BasicReLU
    properties
        type            % 层类型
        input           % 输入维度
        inputDate       % 输入矩阵，用于BP
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Vector Dimension ERROR! %s\n', obj.type);
            end
            
            r = input .* (input > 0);
        end
        function r = backward(obj, dj)
            r = dj .* (obj.inputData > 0);
        end
    end
end