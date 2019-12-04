classdef BasicConv3d < handle
    properties
        type            % 层类型
        input           % 输入维度 (mh, mw, mf)
        filter          % 卷积核 (mh, mw, 1)
        strides         % 一般[1, 1, 1]
        inputData       % 输入数据，用于BP
        learning_rate   % 学习率，用于BP
    end
    methods
        function r = forward(obj, input)
            % 保存输入维度
            obj.input = size(input);
            
            % 进行卷积
            % 保存输入数据，用于BP时的反卷积
            obj.inputData = input;
            % 直接卷积，不像之前的一样分通道
            r = conv3(input, obj.filter, obj.strides, 'valid');
        end
        function r = backward(obj, dj)
            if ndims(dj) == 2
                [tf, ~] = size(dj);
                dj = reshape(dj, 1, 1, tf);
            end
            % 根据卷积步长填充零
            % 如果步长为[1, 1, 1]，则直接返回dj
            % 测试时先使strides为[1, 1, 1]
            dj_fill = mFillZero(dj, obj.strides);
            
            % 详情见3D卷积公式
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
            dFilter = conv3(obj.inputData, dj_fill, [1, 1, 1], 'valid');
            obj.filter = obj.filter - obj.learning_rate * dFilter;
            
            % 反卷积得到结果，调用conv3
            r = conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
        end
    end
end