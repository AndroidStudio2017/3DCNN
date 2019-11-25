% conv3:    ��ά������ر�����3dCNN��
%       mat:        3D�����   (h, w, f)
%       filter:     3D����ˣ����и���ά��    (h, w, f, fm)
%       strides:    3D����     (h, w, f)
%       padding:    same��vaild
function [ res ] = conv3(mat, filter, strides, padding)
    % ���padding����
    if (strcmp(padding, 'same') == 0 && strcmp(padding, 'valid') == 0)
        error('[ERROR] You have wrong "padding" argument.');
    end

    % ���������same����������ά�ȶ���mat��������
    [mh, mw, mf] = size(mat);
    if (strcmp(padding, 'same'))
        tmp = zeros(mh+2, mw+2, mf+2);
        tmp(2:mh+1, 2:mw+1, 2:mf+1) = mat;
        mat = tmp;
    end

    [mh, mw, mf] = size(mat);
    [fh, fw, ff, fm] = size(filter);
    s1 = strides(1); s2 = strides(2); s3 = strides(3);
    
    % Ϊ�������Ԥ����ռ�
    rh = floor((mh-fh)/s1) + 1;
    rw = floor((mw-fw)/s2) + 1;
    rf = floor((mf/3-ff)/s3) + 1;
    res = zeros(rh, rw, rf * 3 * fm);
   
    % ������ά�������
    idx = 0;
    for f = 1:fm                                                                                % һ��һ������˽������㣬���õ�һ�������
        for filter_start = 0:2                                                                             % ������RGB���εĵ�һ��   % ���ڼ�¼������һ��
            for j = 1:rf                                                                        % ��һ����Ҫ����rf����ά���
                mat_start = filter_start * mf /3 + (j-1) * strides(3) + 1;                          % ���㵱ǰӦ�ô������������￪ʼ�����˾��
                % idx = ((f-1)*3 + filter_start) * rf + j;                                               % ���㵱ǰӦ�ü�����һ����ά���
                idx = idx + 1;
                for k = 1:ff                                                                    % �þ���;���˽��о��
                    res(:, :, idx) = res(:, :, idx) + mConv2(mat(:, :, mat_start + k - 1), ...
                                    filter(:, :, k, f), [strides(1), strides(2)], 'valid');
                end
            end
        end
    end
end