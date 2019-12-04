classdef BasicConv3dbyChannels < handle
    properties
        type                % 类型
        input               % 输入维度  (h, w, f)
        filter              % 卷积核    (fh, fw, fn, fm)
        strides             % 步长
        inputData           % 输入数据，用于BP
        learning_rate       % 学习率，用于BP
    end
    methods
        % 3dCNN的前馈算法
        function r = forward(obj, input)
            % 进行卷积
            obj.inputData = input;                                                  % 保存输入，用于BP时反卷积
            % 分通道进行卷积，前提保证input是一段视频的RGB通道帧构成 
            % 形如(R1, R2, R3, ... RN, G1, G2, G3, ... GN, B1, B2, B3, ... BN)
            % 在进行3D卷积时：
            % 1. 第一个卷积核卷积
            %   1.1 第一个卷积核对(R1, R2, R3, ... RN)卷积
            %   1.2 第一个卷积核对(G1, G2, G3, ... GN)卷积
            %   1.3 第一个卷积核对(B1, B2, B3, ... BN)卷积
            % 2. 第二个卷积核卷积
            %   ...
            % ...
            % 最终结果也是以上述顺序进行组织的
            r = conv3byChannels(input, obj.filter, obj.strides, 'valid');           
        end
        function r = backward(obj, dj)
            % 分核分通道进行反卷积求解Filter的梯度
            [th, tw, tf] = size(dj);               
            [fh, fw, ff, fm] = size(obj.filter); 
            [ih, iw, in] = size(obj.inputData);
            
            % 这部分的思路：
            % 求解3D卷积核梯度的方法，是用传递回来的dj去卷积原输入，
            % 但由于原来进行3D卷积时是分核分通道进行的，
            % 1. 首先为各个filter的变化量分配空间
            % 2. range_in(1)表示对应被卷积的input的起始位置
            %    range_in(2)表示对应被卷积的input的结束位置
            % 3. range_dj(1)表示对应error卷积核的起始位置
            %    range_dj(2)表示对应error卷积核的结束位置
            % 4. 因为每个卷积核都有三个运算梯度，考虑都是误差，所以这里采用三个结果之和作为filter的梯度。
            dFilter = zeros(fh, fw, ff, fm);
            for i=1:fm
                for j=0:2
                    range_in = [j*(in/3) + 1, (j+1)*(in/3)];
                    range_dj = [((i-1)*3+j)*(tf/(3*fm)) + 1, ((i-1)*3+j+1)*(tf/(3*fm))];
                    dFilter(:, :, :, i) = dFilter(:, :, :, i) + ...
                        conv3(obj.inputData(:, :, range_in(1):range_in(2)), ...
                        dj(:, :, range_dj(1):range_dj(2)), [1, 1, 1], 'valid');
                end
            end
            
            segment = tf/(3*fm);
            
            % 分通道传递dj
            % 思路如下：
            % 同样是根据3D卷积前馈运算进行反推，在反向传播误差的时候，传播的误差
            % 应该是error对于该层输入的梯度，就应该用旋转180度的卷积核去卷积填充0
            % 之后的dj.
            % 因为其作为第一层，所以反传递的误差没有影响。
            % 
            % ---- R通道 ----
            % 根据卷积步长填充零
            error_R = zeros(ih, iw, in/3);
            for i=1:(segment*3):tf
                % 如果strides=[1, 1, 1]，则直接返回参数一的矩阵
                % 如果strides~=[1, 1, 1]，那么填充一定的0之后返回
                % 测试阶段strides=[1, 1, 1]
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % 将dj按照反卷积公式扩展零
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % 将卷积核反转
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % 反卷积得到结果，调用conv3
                error_R = error_R + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_R = error_R / fm;
            
            % ---- G ----
            % 根据卷积步长填充零
            error_G = zeros(ih, iw, in/3);
            for i=(segment+1):(segment*3):tf
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % 将dj按照反卷积公式扩展零
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % 将卷积核反转
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % 反卷积得到结果，调用conv3
                error_G = error_G + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_G = error_G / fm;
            
            % ---- B ----
            % 根据卷积步长填充零
            error_B = zeros(ih, iw, in/3);
            for i=(2*segment+1):(segment*3):tf
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % 将dj按照反卷积公式扩展零
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % 将卷积核反转
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % 反卷积得到结果，调用conv3
                error_B = error_B + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_B = error_B / fm;
            
            % r
            [gh, gw, gf] = size(error_G);
            r = zeros(gh, gw, 3*gf);

            r(:, :, 1:gf) = error_R;
            r(:, :, (gf+1):(gf*2)) = error_G;
            r(:, :, (2*gf+1):(gf*3)) = error_B;
            
            % 根据dj更新卷积核
            obj.filter = obj.filter - obj.learning_rate * dFilter;
        end
    end
end