
function [ result ] = mBackward(net, real_label)
    % ��Ϊ�м��������������֮��Ľ��
    err_trans = real_label;

    % ����net�ṹ�岢����
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