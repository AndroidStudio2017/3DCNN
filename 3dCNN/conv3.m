% conv3:    ��ά���������ͨ����ֱ�Ӿ��
%       mat:        3D�����   (h, w, f)
%       filter:     3D����ˣ����и���ά��    (h, w, f, fm)
%       strides:    3D����     (h, w, f)
%       padding:    same��vaild
function [ res ] = conv3(mat, filter, strides, padding)
    % ���padding������ֻ����'same'����'valid'
    if (strcmp(padding, 'same') == 0 && strcmp(padding, 'valid') == 0)
        error('[ERROR] You have wrong "padding" argument.');
    end
    
    % ���������same����������ά�ȶ���mat��������
    % ���䷽�����Ƚ���һ��������С�������Ȼ������м䲿����ԭ����������
    [mh, mw, mf] = size(mat);
    if (strcmp(padding, 'same'))
        tmp = zeros(mh+2, mw+2, mf+2);
        tmp(2:mh+1, 2:mw+1, 2:mf+1) = mat;
        mat = tmp;
    end
    
    [mh, mw, mf] = size(mat);
    [fh, fw, ff, fm] = size(filter);
    s1 = strides(1); s2 = strides(2); s3 = strides(3);
    
    % Ϊ�������Ԥ����ռ䣬����ά�ȶ�ֱ���þ����ʽ����
    rh = floor((mh-fh)/s1) + 1;
    rw = floor((mw-fw)/s2) + 1;
    rf = floor((mf-ff)/s3) + 1;
    % ���ڲ���ͨ������������rf��ֱ��*fm������*3
    res = zeros(rh, rw, rf*fm);
    
    % ������ά�������
    idx = 0;            % ��������֡��ά������
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