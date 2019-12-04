classdef BasicConv3dbyChannels < handle
    properties
        type                % ����
        input               % ����ά��  (h, w, f)
        filter              % �����    (fh, fw, fn, fm)
        strides             % ����
        inputData           % �������ݣ�����BP
        learning_rate       % ѧϰ�ʣ�����BP
    end
    methods
        % 3dCNN��ǰ���㷨
        function r = forward(obj, input)
            % ���о��
            obj.inputData = input;                                                  % �������룬����BPʱ�����
            % ��ͨ�����о����ǰ�ᱣ֤input��һ����Ƶ��RGBͨ��֡���� 
            % ����(R1, R2, R3, ... RN, G1, G2, G3, ... GN, B1, B2, B3, ... BN)
            % �ڽ���3D���ʱ��
            % 1. ��һ������˾��
            %   1.1 ��һ������˶�(R1, R2, R3, ... RN)���
            %   1.2 ��һ������˶�(G1, G2, G3, ... GN)���
            %   1.3 ��һ������˶�(B1, B2, B3, ... BN)���
            % 2. �ڶ�������˾��
            %   ...
            % ...
            % ���ս��Ҳ��������˳�������֯��
            r = conv3byChannels(input, obj.filter, obj.strides, 'valid');           
        end
        function r = backward(obj, dj)
            % �ֺ˷�ͨ�����з�������Filter���ݶ�
            [th, tw, tf] = size(dj);               
            [fh, fw, ff, fm] = size(obj.filter); 
            [ih, iw, in] = size(obj.inputData);
            
            % �ⲿ�ֵ�˼·��
            % ���3D������ݶȵķ��������ô��ݻ�����djȥ���ԭ���룬
            % ������ԭ������3D���ʱ�Ƿֺ˷�ͨ�����еģ�
            % 1. ����Ϊ����filter�ı仯������ռ�
            % 2. range_in(1)��ʾ��Ӧ�������input����ʼλ��
            %    range_in(2)��ʾ��Ӧ�������input�Ľ���λ��
            % 3. range_dj(1)��ʾ��Ӧerror����˵���ʼλ��
            %    range_dj(2)��ʾ��Ӧerror����˵Ľ���λ��
            % 4. ��Ϊÿ������˶������������ݶȣ����Ƕ�����������������������֮����Ϊfilter���ݶȡ�
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
            
            % ��ͨ������dj
            % ˼·���£�
            % ͬ���Ǹ���3D���ǰ��������з��ƣ��ڷ��򴫲�����ʱ�򣬴��������
            % Ӧ����error���ڸò�������ݶȣ���Ӧ������ת180�ȵľ����ȥ������0
            % ֮���dj.
            % ��Ϊ����Ϊ��һ�㣬���Է����ݵ����û��Ӱ�졣
            % 
            % ---- Rͨ�� ----
            % ���ݾ�����������
            error_R = zeros(ih, iw, in/3);
            for i=1:(segment*3):tf
                % ���strides=[1, 1, 1]����ֱ�ӷ��ز���һ�ľ���
                % ���strides~=[1, 1, 1]����ô���һ����0֮�󷵻�
                % ���Խ׶�strides=[1, 1, 1]
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % ��dj���շ������ʽ��չ��
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % ������˷�ת
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % ������õ����������conv3
                error_R = error_R + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_R = error_R / fm;
            
            % ---- G ----
            % ���ݾ�����������
            error_G = zeros(ih, iw, in/3);
            for i=(segment+1):(segment*3):tf
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % ��dj���շ������ʽ��չ��
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % ������˷�ת
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % ������õ����������conv3
                error_G = error_G + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_G = error_G / fm;
            
            % ---- B ----
            % ���ݾ�����������
            error_B = zeros(ih, iw, in/3);
            for i=(2*segment+1):(segment*3):tf
                dj_fill = mFillZero(dj(:, :, i:i+segment-1), obj.strides);
            
                % ��dj���շ������ʽ��չ��
                [dh, dw, df] = size(dj_fill);
                [fh, fw, ff, fm] = size(obj.filter);
                eh = dh + 2*(fh-1);
                ew = dw + 2*(fw-1);
                ef = df + 2*(ff-1);
                dj_extend = zeros(eh, ew, ef);
                dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
                
                % ������˷�ת
                filter_reverse = mReverse3d(obj.filter(:, :, :, floor(i/(segment*3))+1));
                
                % ������õ����������conv3
                error_B = error_B + conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
            end
            error_B = error_B / fm;
            
            % r
            [gh, gw, gf] = size(error_G);
            r = zeros(gh, gw, 3*gf);

            r(:, :, 1:gf) = error_R;
            r(:, :, (gf+1):(gf*2)) = error_G;
            r(:, :, (2*gf+1):(gf*3)) = error_B;
            
            % ����dj���¾����
            obj.filter = obj.filter - obj.learning_rate * dFilter;
        end
    end
end