% mForward: 神经网络前馈运算
%       net:    网络结构体，由用户自定义
%       input:  3DCNN的输入 (height, weight, frames)
function [ result ] = mForward( net, input)
    
    % 作为中间变量，传递两层之间的结果
    res_trans = input;

    % 解析net结构体并运算
    fields = fieldnames(net);
    for i = 1:length(fields)
        k = fields(i);
        key = k{1};
        module = net.(key);
        
        % Debug
        % size(res_trans)
        res_trans = module.forward(res_trans);
    end
    
    result = res_trans;
end