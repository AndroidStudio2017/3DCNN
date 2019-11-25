classdef BasicFullConnection
    properties
        type            % 层的类型
        input           % 输入维度 (h, w, f)
        arguments       % 参数
        bias            % 偏置bias
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            [mh, mw, mf] = size(input);
            if mh == 1 && mw == 1
                % 将输入全连接层的形式转化为向量，用于之后的矩阵乘法
                input = reshape(input(1, 1, :), mf, 1);
                % 全连接前馈就是直接矩阵乘法a = θx
                r = obj.arguments * input + obj.bias;
            else
                error('[ERROR] Matrix which input to FullConnection Layer is not a Vector!');
            end
        end
        
        function r = backward(obj, dj)
            
        end
    end
end