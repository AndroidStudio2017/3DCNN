% mLoss:    ��������ʧ����������softmax���������ʵ���������Ĳ��
%       estimate:       softmax�����
%       groundtruth:    ԭ��Ƶ�ı�ǩ
function [ result ] = mLoss(estimate, groundtruth)
    proc = groundtruth .* log(estimate);
    
    result = -sum(proc(:));
end