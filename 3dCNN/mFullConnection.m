function [ layer ] = mFullConnection(arguments, bias, learning_rate)
    layer = BasicFullConnection;
    layer.arguments = arguments;
    layer.type = 'FullConnection';
    layer.bias = bias;
    layer.learning_rate = learning_rate;
end