function [ layer ] = mFullConnection(input, arguments, bias)
    layer = BasicFullConnection;
    layer.input = input;
    layer.arguments = arguments;
    layer.type = 'FullConnection';
    layer.bias = bias;
end