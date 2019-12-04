classdef BasicConv3d < handle
    properties
        type            % ������
        input           % ����ά�� (mh, mw, mf)
        filter          % ����� (mh, mw, 1)
        strides         % һ��[1, 1, 1]
        inputData       % �������ݣ�����BP
        learning_rate   % ѧϰ�ʣ�����BP
    end
    methods
        function r = forward(obj, input)
            % ��������ά��
            obj.input = size(input);
            
            % ���о��
            % �����������ݣ�����BPʱ�ķ����
            obj.inputData = input;
            % ֱ�Ӿ��������֮ǰ��һ����ͨ��
            r = conv3(input, obj.filter, obj.strides, 'valid');
        end
        function r = backward(obj, dj)
            if ndims(dj) == 2
                [tf, ~] = size(dj);
                dj = reshape(dj, 1, 1, tf);
            end
            % ���ݾ�����������
            % �������Ϊ[1, 1, 1]����ֱ�ӷ���dj
            % ����ʱ��ʹstridesΪ[1, 1, 1]
            dj_fill = mFillZero(dj, obj.strides);
            
            % �����3D�����ʽ
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
            dFilter = conv3(obj.inputData, dj_fill, [1, 1, 1], 'valid');
            obj.filter = obj.filter - obj.learning_rate * dFilter;
            
            % ������õ����������conv3
            r = conv3(dj_extend, filter_reverse, [1, 1, 1], 'valid');
        end
    end
end