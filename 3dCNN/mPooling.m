% mPooling: 池化操作，比原来的matlab多了一些strides操作
%       mat:        要进行池化操作的矩阵
%       ksize:      池化窗口
%       type:       池化种类, max_pool、mean_pool
function [ result, indexRow, indexCol ] = mPooling(mat, ksize, type)
    [mh, mw, mf] = size(mat);
    
    rf = mf;                        % 只对宽、高维度进行池化
    rh = floor((mh - ksize(1))/ksize(1)) + 1;
    rw = floor((mw - ksize(2))/ksize(2)) + 1;
    
    % 为结果提前分配空间
    result = zeros(rh, rw, rf);
    
    % indexRow(i, j, k):（仅max_pool有效）
    % 记录了result(i, j, k)的值在原来未池化矩阵中的位置(行)。
    % 
    % indexCol(i, j, k):（仅max_pool有效）
    % 记录了result(i, j, k)的值在原来未池化矩阵中的位置(列)。
    indexRow = zeros(rh, rw, rf);
    indexCol = zeros(rh, rw, rf);
    
    % 池化操作，应该可以并行化
    for i = 1:rf
        for j=1:rh
            for k=1:rw
                % left_up计算池化后的(i, j, k)点对应于原来位置块的左上角坐标
                left_up = [(j-1)*ksize(1) + 1, (k-1)*ksize(2) + 1];
                % submat取出以left_up为左上角元素，高ksize(1)，宽ksize(2)的子矩阵
                % 即池矩阵
                submat = mat(left_up(1):left_up(1)+ksize(1)-1,       ...
                            left_up(2):left_up(2)+ksize(2)-1, i);
                % 判断池化种类
                % 若为最大池(max_pool)，求取池中的最大值，并记录最大值的位置
                % 若为平均池(mean_pool)，求取池中的平均值
                if strcmp(type, 'max_pool')
                    % matlab仅提供一维的argmax
                    % 这里将submat按列变为列向量，然后求取最大值，在变换为二维的坐标
                    [num, idx] = max(submat(:));
                    idx = idx - 1;          % 变为从0开始
                    % 记录最大值位置
                    col = floor(idx / ksize(1));
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