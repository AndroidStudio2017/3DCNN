% conv3:    三维卷积，特别用于3dCNN中
%       mat:        3D大矩阵   (h, w, f)
%       filter:     3D卷积核，还有个数维度    (h, w, f, fm)
%       strides:    3D步长
%       padding:    same、vaild
function [ res ] = conv3(mat, filter, strides, padding)
    % 检查padding参数
    if (strcmp(padding, 'same') == 0 && strcmp(padding, 'valid') == 0)
        error('[ERROR] You have wrong "padding" argument.');
    end

    % 如果参数是same，则在三个维度都对mat进行扩充
    [mh, mw, mf] = size(mat);
    if (strcmp(padding, 'same'))
        tmp = zeros(mh+2, mw+2, mf+2);
        tmp(2:mh+1, 2:mw+1, 2:mf+1) = mat;
        mat = tmp;
    end

    [mh, mw, mf] = size(mat);
    [fm, ff, fh, fw] = size(filter);
    s1 = strides(1); s2 = strides(2); s3 = strides(3);
    
    % 为结果矩阵预分配空间
    rf = floor((mf/3-ff)/s1) + 1;
    rh = floor((mh-fh)/s2) + 1;
    rw = floor((mw-fw)/s3) + 1;
    res = zeros(rf * 3 * fm, rh, rw);
   
    % 进行三维卷积运算
    idx = 0;
    for f = 1:fm                                                                                % 一个一个卷积核进行运算，先拿第一个卷积核
        for filter_start = 0:2                                                                             % 作用于RGB三段的第一段   % 用于记录到了哪一段
            for j = 1:rf                                                                        % 第一段中要计算rf个二维结果
                mat_start = filter_start * mf /3 + (j-1) * strides(1);                          % 计算当前应该从输入矩阵的哪里开始与卷积核卷积
                % idx = ((f-1)*3 + filter_start) * rf + j;                                               % 计算当前应该计算哪一个二维结果
                idx = idx + 1;
                for k = 1:ff                                                                    % 用矩阵和卷积核进行卷积
                    res(idx, :, :) = reshape(res(idx, :, :), rh, rw) + mConv2(reshape(mat(mat_start + k, :, :), mh, mw), ...
                                    reshape(filter(f, k, :, :), fh, fw), [strides(2), strides(3)], 'valid');
                end
            end
        end
    end
end