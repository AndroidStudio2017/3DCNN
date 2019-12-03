% conv3:    三维卷积，不分通道，直接卷积
%       mat:        3D大矩阵   (h, w, f)
%       filter:     3D卷积核，还有个数维度    (h, w, f, fm)
%       strides:    3D步长     (h, w, f)
%       padding:    same、vaild
function [ res ] = conv3(mat, filter, strides, padding)
    % 检查padding参数，只能是'same'或者'valid'
    if (strcmp(padding, 'same') == 0 && strcmp(padding, 'valid') == 0)
        error('[ERROR] You have wrong "padding" argument.');
    end
    
    % 如果参数是same，则在三个维度都对mat进行扩充
    % 扩充方法是先建立一个扩充后大小的零矩阵，然后对其中间部分用原矩阵进行填充
    [mh, mw, mf] = size(mat);
    if (strcmp(padding, 'same'))
        tmp = zeros(mh+2, mw+2, mf+2);
        tmp(2:mh+1, 2:mw+1, 2:mf+1) = mat;
        mat = tmp;
    end
    
    [mh, mw, mf] = size(mat);
    [fh, fw, ff, fm] = size(filter);
    s1 = strides(1); s2 = strides(2); s3 = strides(3);
    
    % 为结果矩阵预分配空间，三个维度都直接用卷积公式计算
    rh = floor((mh-fh)/s1) + 1;
    rw = floor((mw-fw)/s2) + 1;
    rf = floor((mf-ff)/s3) + 1;
    % 由于不分通道，所以这里rf就直接*fm，不用*3
    res = zeros(rh, rw, rf*fm);
    
    % 进行三维卷积运算
    idx = 0;            % 结果矩阵的帧数维度索引
    for i=1:fm
        for j=1:rf
            mat_start = (j-1) * s3 + 1;
            idx = idx + 1;
            for k=1:ff
                res(:, :, idx) = res(:, :, idx) + mConv2(mat(:, :, mat_start + k - 1) ...
                    , filter(:, :, k, i), [s1, s2], 'valid');
            end
        end
    end
end