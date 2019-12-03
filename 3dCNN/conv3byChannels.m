% conv3byChannels:    三维卷积，分通道进行
%       mat:        3D大矩阵   (h, w, f)
%       filter:     3D卷积核，还有个数维度    (h, w, f, fm)
%       strides:    3D步长     (h, w, f)
%       padding:    same、vaild
function [ res ] = conv3byChannels(mat, filter, strides, padding)
    % 检查padding参数，只能是'same'或者'valid'
    if (strcmp(padding, 'same') == 0 && strcmp(padding, 'valid') == 0)
        error('[ERROR] You have wrong "padding" argument.');
    end

    % 如果参数是same，则在三个维度都对mat进行扩充
    % 扩充方法是先建立一个扩充后大小的零矩阵，然后把这个零矩阵的中间部分用原矩阵填充
    [mh, mw, mf] = size(mat);
    if (strcmp(padding, 'same'))
        tmp = zeros(mh+2, mw+2, mf+2);
        tmp(2:mh+1, 2:mw+1, 2:mf+1) = mat;
        mat = tmp;
    end

    [mh, mw, mf] = size(mat);
    [fh, fw, ff, fm] = size(filter);
    s1 = strides(1); s2 = strides(2); s3 = strides(3);
    
    % 为结果矩阵预分配空间
    rh = floor((mh-fh)/s1) + 1;     % 直接用卷积公式
    rw = floor((mw-fw)/s2) + 1;     % 直接用卷积公式
    rf = floor((mf/3-ff)/s3) + 1;   % 因为这里卷积是分通道进行，所以mf/3求出每个通道的长度
                                    % 然后对每个通道，用卷积核进行卷积，求出每个通道卷积后的长度rf
    res = zeros(rh, rw, rf * 3 * fm);  % 前两个维度长度根据上述卷积公式确定
                                       % 第三个维度是将每个通道卷积的长度*3*fm     
   
    % 进行三维卷积运算
    idx = 0;        % 标记结果矩阵帧数维度的idx
    for f = 1:fm                                                                                % 一个一个卷积核进行运算，先拿第一个卷积核
        for filter_start = 0:2                                                                             % 作用于RGB三段的第一段   % 用于记录到了哪一段
            for j = 1:rf                                                                        % 第一段中要计算rf个二维结果
                mat_start = filter_start * mf /3 + (j-1) * s3 + 1;                          % 计算当前应该从输入矩阵的哪里开始与卷积核卷积
                % idx = ((f-1)*3 + filter_start) * rf + j;                                               % 计算当前应该计算哪一个二维结果
                idx = idx + 1;
                for k = 1:ff                                                                    % 用矩阵和卷积核进行卷积
                    res(:, :, idx) = res(:, :, idx) + mConv2(mat(:, :, mat_start + k - 1), ...
                                    filter(:, :, k, f), [s1, s2], 'valid');
                end
            end
        end
    end
end