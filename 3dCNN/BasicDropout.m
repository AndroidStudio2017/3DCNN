classdef BasicDropout < handle
    properties
        type            % 层类型
        input           % 输入维度
        p               % dropout概率
        random          % 记录前馈时候随机的那些神经元，用于BP
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            % 进行dropout
            obj.random = rand(size(input));
            input(obj.random <= obj.p) = -1;         % 置成-1再加上ReLU函数就是0
            r = input / (1 - obj.p);            % 对其他的神经元进行缩放
        end
        function r = backward(obj, dj)
            temp = obj.random > obj.p;
            gradientDrop = dj .* (temp / (1 - obj.p));
            r = gradientDrop;
        end
    end
end