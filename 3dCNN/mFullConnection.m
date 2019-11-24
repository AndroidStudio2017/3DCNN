function [ layer ] = mFullConnection(input, arguments)
    layer = BasicFullConnection;
    layer.input = zeros(input(1), input(2), input(3));
    layer.arguments = arguments;
    layer.type = 'FullConnection';
end