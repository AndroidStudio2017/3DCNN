% mPooling: �ػ���������ԭ����matlab����һЩstrides����
%       mat:        Ҫ���гػ������ľ���
%       ksize:      �ػ�����
%       type:       �ػ�����, max_pool��mean_pool
function [ result, indexRow, indexCol ] = mPooling(mat, ksize, type)
    [mh, mw, mf] = size(mat);
    
    rf = mf;                        % ֻ�Կ���ά�Ƚ��гػ�
    rh = floor((mh - ksize(1))/ksize(1)) + 1;
    rw = floor((mw - ksize(2))/ksize(2)) + 1;
    
    % Ϊ�����ǰ����ռ�
    result = zeros(rh, rw, rf);
    
    % indexRow(i, j, k):����max_pool��Ч��
    % ��¼��result(i, j, k)��ֵ��ԭ��δ�ػ������е�λ��(��)��
    % 
    % indexCol(i, j, k):����max_pool��Ч��
    % ��¼��result(i, j, k)��ֵ��ԭ��δ�ػ������е�λ��(��)��
    indexRow = zeros(rh, rw, rf);
    indexCol = zeros(rh, rw, rf);
    
    % �ػ�������Ӧ�ÿ��Բ��л�
    for i = 1:rf
        for j=1:rh
            for k=1:rw
                % left_up����ػ����(i, j, k)���Ӧ��ԭ��λ�ÿ�����Ͻ�����
                left_up = [(j-1)*ksize(1) + 1, (k-1)*ksize(2) + 1];
                % submatȡ����left_upΪ���Ͻ�Ԫ�أ���ksize(1)����ksize(2)���Ӿ���
                % ���ؾ���
                submat = mat(left_up(1):left_up(1)+ksize(1)-1,       ...
                            left_up(2):left_up(2)+ksize(2)-1, i);
                % �жϳػ�����
                % ��Ϊ����(max_pool)����ȡ���е����ֵ������¼���ֵ��λ��
                % ��Ϊƽ����(mean_pool)����ȡ���е�ƽ��ֵ
                if strcmp(type, 'max_pool')
                    % matlab���ṩһά��argmax
                    % ���ｫsubmat���б�Ϊ��������Ȼ����ȡ���ֵ���ڱ任Ϊ��ά������
                    [num, idx] = max(submat(:));
                    idx = idx - 1;          % ��Ϊ��0��ʼ
                    % ��¼���ֵλ��
                    col = floor(idx / ksize(1));
                    row = mod(idx, ksize(1));
                    indexRow(j, k, i) = left_up(1) + row;
                    indexCol(j, k, i) = left_up(2) + col;
                    % ǰ���ػ�����
                    result(j, k, i) = num;
                elseif strcmp(type, 'mean_pool') 
                    result(j, k, i) = floor(mean(submat(:)));
                else
                    error('[ERROR] Arguments ERROR! mPooling');
                end
            end
        end
    end
end