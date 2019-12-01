classdef BasicConv3d < handle
    properties
        type                % 类型
        input               % 输入维度  (h, w, f)
        filter              % 卷积核    (fh, fw, fn, fm)
        strides             % 步长
        inputData           % 输入数据，用于BP
    end
    methods
        % 3dCNN的前馈算法
        function r = forward(obj, input)
            % 检测输入矩阵和一开始计算的维度是否相等，一个简单的错误检测机制
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            % 进行卷积
            % size(input)
            % size(obj.filter)
            obj.inputData = input;
            r = conv3(input, obj.filter, obj.strides, 'valid');
        end
        function r = backward(obj, dj)
            if ndims(dj) == 2
                [tf, ~] = size(dj);
                dj = reshape(dj, 1, 1, tf);
            end
            % 根据卷积步长填充零
            dj_fill = mFillZero(dj, obj.strides);
            
            % 将dj按照反卷积公式扩展零
            [dh, dw, df] = size(dj_fill);
            [fh, fw, ff] = size(obj.filter);
            eh = dh + 2*(fh-1);
            ew = dw + 2*(fw-1);
            ef = df + 2*(ff-1);
            dj_extend = zeros(eh, ew, ef);
            dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
            
            % 将卷积核反转
            filter_reverse = mReverse3d(obj.filter);
            
            % 更新卷积核
            obj.filter = conv3(obj.inputData, dj_fill, [1, 1, 1], 'valid');
            size(obj.filter)
            
            % 反卷积得到结果，调用conv3
            r = conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
        end
    end
end