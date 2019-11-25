classdef BasicFullConnection
    properties
        type            % �������
        input           % ����ά�� (h, w, f)
        arguments       % ����
        bias            % ƫ��bias
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            [mh, mw, mf] = size(input);
            if mh == 1 && mw == 1
                % ������ȫ���Ӳ����ʽת��Ϊ����������֮��ľ���˷�
                input = reshape(input(1, 1, :), mf, 1);
                % ȫ����ǰ������ֱ�Ӿ���˷�a = ��x
                r = obj.arguments * input + obj.bias;
            else
                error('[ERROR] Matrix which input to FullConnection Layer is not a Vector!');
            end
        end
        
        function r = backward(obj, dj)
            
        end
    end
end