classdef BasicFullConnection < handle
    properties
        type            % �������
        input           % ����ά�� (h, w, f)
        arguments       % ����
        bias            % ƫ��bias
        inputData       % ��������ݣ�����BP
        learning_rate   % ѧϰ�ʣ�����BP
    end
    methods
        function r = forward(obj, input)
            % �����������һ��ʼ�����ά���Ƿ���ȣ�һ���򵥵Ĵ��������
            if obj.input ~= size(input)
                error('[ERROR] Matrix Dimension ERROR! %s\n', obj.type);
            end
            
            [mh, mw, mf] = size(input);
            % ���ά�ȣ��ж��Ǿ���������
            if ndims(input) == 3 && mh == 1 && mw == 1
                % ������ȫ���Ӳ����ʽת��Ϊ����������֮��ľ���˷�
                input = reshape(input(1, 1, :), mf, 1);
                obj.inputData = input;
                % ȫ����ǰ������ֱ�Ӿ���˷�a = ��x
                r = obj.arguments * input + obj.bias;
            elseif ndims(input) == 2
                obj.inputData = input;
                r = obj.arguments * input + obj.bias;
            else
                error('[ERROR] Matrix which input to FullConnection Layer is not a Vector!');
            end
        end
        
        function r = backward(obj, dj)
            r = obj.arguments' * dj;
            gradientTheata = dj * obj.inputData';
            obj.arguments = obj.arguments - obj.learning_rate * gradientTheata;
            gradientBias = dj;
            obj.bias = obj.bias - obj.learning_rate * gradientBias;
        end
    end
end