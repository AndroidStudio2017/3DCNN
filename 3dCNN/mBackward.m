
function [ result ] = mBackward(net, real_label)
    % 作为中间变量，传递两层之间的结果
    err_trans = real_label;

    % 解析net结构体并运算
    fields = fieldnames(net);
    for i = length(fields):-1:1
        k = fields(i);
        key = k{1};
        module = net.(key);
        
        % Debug
        % module.type
        size(err_trans)
        err_trans = module.backward(err_trans);
    end
    
    result = err_trans;
end