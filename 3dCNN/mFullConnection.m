function [ layer ] = mFullConnection(input, arguments, bias, learning_rate)
    layer = BasicFullConnection;
    layer.input = input;
    layer.arguments = arguments;
    layer.type = 'FullConnection';
    layer.bias = bias;
    layer.learning_rate = learning_rate;
end