classdef BasicConv3d
    properties
        type                % ����
        input               % ����ά��  (h, w, f)
        output              % ���ά��  (h, w, f)
        filter              % �����    (fh, fw, fn, fm)
        strides             % ����
    end
    methods
        % 3dCNN��ǰ���㷨
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            % ���о��
            size(input)
            size(obj.filter)
            r = conv3(input, obj.filter, obj.strides, 'valid');
        end
        function r = backward(obj, dj)
            % ��ʱδʵ��
        end
    end
end