% mPooling: 池化操作，比原来的matlab多了一些strides操作
%       mat:        要进行池化操作的矩阵
%       ksize:      池化窗口
%       type:       池化种类, max_pool、mean_pool
function [ result, indexRow, indexCol ] = mPooling(mat, ksize, type)
    [mh, mw, mf] = size(mat);
    
    % 为结果提前分配空间
    rf = mf;
    rh = floor((mh - ksize(1))/ksize(1)) + 1;
    rw = floor((mw - ksize(2))/ksize(2)) + 1;
    result = zeros(rh, rw, rf);
    indexRow = zeros(rh, rw, rf);
    indexCol = zeros(rh, rw, rf);
    
    for i = 1:rf
        for j=1:rh
            for k=1:rw
                left_up = [(j-1)*ksize(1) + 1, (k-1)*ksize(2) + 1];
                submat = mat(left_up(1):left_up(1)+ksize(1)-1,       ...
                            left_up(2):left_up(2)+ksize(2)-1, i);
                if strcmp(type, 'max_pool')
                    [num, idx] = max(submat(:));
                    idx = idx - 1;          % 变为从0开始
                    % 记录最大值位置
                    col = idx / ksize(1);
                    row = mod(idx, ksize(1));
                    indexRow(j, k, i) = left_up(1) + row;
                    indexCol(j, k, i) = left_up(2) + col;
                    % 前馈池化矩阵
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