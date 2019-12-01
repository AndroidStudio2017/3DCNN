% mReverse:     ���ڷ�ת�����
%           filter:     ����ת�ľ����
function [ result ] = mReverse3d(filter)
    [fh, fw, ff, fm] = size(filter);
    result = zeros(fh, fw, ff, fm);
    
    for i=1:fm
        for j=1:ff
            result(:, :, j, i) = rot90(filter(:, :, ff-j+1, i), 2);
        end
    end
end