classdef BasicConv3d < handle
    properties
        type                % ����
        input               % ����ά��  (h, w, f)
        filter              % �����    (fh, fw, fn, fm)
        strides             % ����
        inputData           % �������ݣ�����BP
    end
    methods
        % 3dCNN��ǰ���㷨
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            % ���о��
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
            % ���ݾ�����������
            dj_fill = mFillZero(dj, obj.strides);
            
            % ��dj���շ������ʽ��չ��
            [dh, dw, df] = size(dj_fill);
            [fh, fw, ff] = size(obj.filter);
            eh = dh + 2*(fh-1);
            ew = dw + 2*(fw-1);
            ef = df + 2*(ff-1);
            dj_extend = zeros(eh, ew, ef);
            dj_extend(fh:fh+dh-1, fw:fw+dw-1, ff:ff+df-1) = dj_fill;
            
            % ������˷�ת
            filter_reverse = mReverse3d(obj.filter);
            
            % ���¾����
            obj.filter = conv3(obj.inputData, dj_fill, [1, 1, 1], 'valid');
            size(obj.filter)
            
            % ������õ����������conv3
            r = conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
        end
    end
end