classdef BasicFullConnection < handle
    properties
        type            % 层的类型
        input           % 输入维度 (h, w, f)
        arguments       % 参数
        bias            % 偏置bias
        inputData       % 输入的数据，用于BP
        learning_rate   % 学习率，用于BP
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            [mh, mw, mf] = size(input);
            % 检测维度，判断是矩阵还是向量
            if ndims(input) == 3 && mh == 1 && mw == 1
                % 将输入全连接层的形式转化为向量，用于之后的矩阵乘法
                input = reshape(input(1, 1, :), mf, 1);
                obj.inputData = input;
                % 全连接前馈就是直接矩阵乘法a = θx
                r = obj.arguments * input + obj.bias;
            elseif ndims(input) == 2
                obj.inputData = input;
                r = obj.arguments * input + obj.bias;
            else
                error('[ERROR] Matrix which input to FullConnection Layer is not a Vector!');
            end
        end
        
        function r = backward(obj, dj)
            r = obj.arguments' * dj;
            gradientTheata = dj * obj.inputData';
            obj.arguments = obj.arguments - obj.learning_rate * gradientTheata;
            gradientBias = dj;
            obj.bias = obj.bias - obj.learning_rate * gradientBias;
        end
    end
end