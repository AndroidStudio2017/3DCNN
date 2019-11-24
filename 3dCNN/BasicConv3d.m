classdef BasicConv3d
    properties
        type                % ����
        input               % ����ά��  (f, h, w)
        output              % ���ά��  (f, h, w)
        filter              % �����    (fm, fn, fh, fw)
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
            r = conv3(input, obj.filter, obj.strides, 'valid');
        end
        function r = backward(obj, dj)
            % ��ʱδʵ��
        end
    end
end