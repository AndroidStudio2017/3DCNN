% mFillZero:    ����ʵ��3D���BP��������mat�У���ÿ����(��/֡)֮�����һ����Ӧ��λ����
%           mat:      ��������  (h, w, f)
%           strides:  ����        (fh, fw, ff)
function [ result ] = mFillZero(mat, strides)
    if strides == [1, 1, 1]
        result = mat;
    else
        [mh, mw, mf] = size(mat);
        sh=strides(1); sw=strides(2); sf=strides(3);

        rh = mh + (mh-1)*(sh-1);
        rw = mw + (mw-1)*(sw-1);
        rf = mf + (mf-1)*(sf-1);
        result = zeros(rh, rw, rf);
        
        % �ɸ��ı���ѭ�������Ч��
        for i=1:mh
            for j=1:mw
                for k=1:mf
                    h = sh*(i-1) + 1;
                    w = sw*(j-1) + 1;
                    f = sf*(k-1) + 1;
                    result(h, w, f) = mat(i, j, k);
                end
            end
        end
    end  
end