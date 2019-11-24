classdef BasicPool
    properties
        type            % 池化种类，max_pool和mean_pool
        input           % 输入
        ksize           % 池化窗口边长
        strides         % 步长，一般选择与ksize一样
    end
    methods
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            
        end
        function r = backward(obj, dj)
            
        end
    end
end