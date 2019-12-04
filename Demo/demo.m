addpath(genpath('../3dCNN'))                % ������ļ�����·��
addpath(genpath('../utils'))
%% ��������
minW = 384;
minH = 270;

%% ��ȡ��Ƶ����
videoRaw = VideoReader('../../video/Truthful/trial_truth_001.mp4');
real_label = [0;1];

nFrames = 100;
height = minH;
width = minW;

%% ������������
img_R = zeros(height, width, nFrames); 
img_G = zeros(height, width, nFrames); 
img_B = zeros(height, width, nFrames);

for i = 1:nFrames
    im = imresize(read(videoRaw, i), [minH, minW]);
    [R, G, B] = separateRGB(im);
    img_R(:, :, i) = R;
    img_G(:, :, i) = G;
    img_B(:, :, i) = B;
end

%% Test for inputArray
inputArray = uint8(cat(3, img_R, img_G, img_B));

%% Test
    
% ǰ�򴫲�
fprintf('ǰ�򴫲��� ...\n');
estiRes = mForward(net, inputArray);

% Loss
error = mLoss(estiRes, real_label);
error_total = [error_total, error];
fprintf('��������ʧ�������: %f\n', error);
