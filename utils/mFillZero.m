% mFillZero:    辅助实现3D卷积BP，用于在mat中，将每两行(列/帧)之间填充一个相应单位的零
%           mat:      待填充矩阵  (h, w, f)
%           strides:  步长        (fh, fw, ff)
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
        
        % 可更改遍历循序，以提高效率
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