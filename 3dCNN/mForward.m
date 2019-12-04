% mForward: ������ǰ������
%       net:    ����ṹ�壬���û��Զ���
%       input:  3DCNN������ (height, weight, frames)
function [ result ] = mForward( net, input)
    
    % ��Ϊ�м��������������֮��Ľ��
    res_trans = input;

    % ����net�ṹ�岢����
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