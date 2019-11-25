clc
clear
close all
addpath(genpath('../3dCNN'))                % ������ļ�����·��

%% ����һЩ�ɵ����Ĳ���
videoFile = '../../video/test.mp4';            % ��Ƶ�ļ���

%% ����video,�Լ���Ӧ����
videoRaw = VideoReader(videoFile);

% nFrames = videoRaw.NumberOfFrames;
nFrames = 10;       % ̫������㲻����
height = videoRaw.Height;
width = videoRaw.Width;

%% ������������
img_R = zeros(height, width, nFrames); 
img_G = zeros(height, width, nFrames); 
img_B = zeros(height, width, nFrames);

for i = 1:nFrames
    im = read(videoRaw, i);
    [R, G, B] = separateRGB(im);
    img_R(:, :, i) = R;
    img_G(:, :, i) = G;
    img_B(:, :, i) = B;
end

%% Test for inputArray
% size(uint8(reshape(img_R(1, :, :), height, width)));
inputArray = uint8(cat(3, img_R, img_G, img_B));
% size(inputArray)
% imshow(reshape(inputArray(19, :, :), height, width));

%% ���� net
% �����
% ����������ʼ��
fm = 32;                                    % ����˸���
fSize = [5, 5, 5];                          % ����˴�С (fh, fw, fn, fm)

input = [height, width, nFrames];
filter = rand(fSize(1), fSize(2), fSize(3), fm);
strides = [1, 1, 1];
conv1 = mConv3d(input, filter, strides);  

% �ػ���   ** �ػ��߽�ֱ�Ӳ�����
input(1) = floor((height - fSize(1))/strides(1)) + 1;
input(2) = floor((width - fSize(2))/strides(2)) + 1;
input(3) = fm * 3 * floor((nFrames - fSize(3))/strides(3) + 1);
ksize = [3, 3];
strides = [3, 3];
max_pool = mPool(input, ksize, strides, 'max_pool');

% ȫ���Ӳ�  ** ���ӳػ����ȫ���Ӳ�ĵط�����ʵ���ʻ���һ�������
input(1) = floor((input(1) - ksize(1))/strides(1)) + 1;
input(2) = floor((input(2) - ksize(2))/strides(2)) + 1;
filter = rand(int8(input(2)), int8(input(3)), 1, 1);
strides = [1, 1, 1];
full_connection1 = mConv3d(input, filter, strides);

% ȫ���Ӳ�
input(1) = 1;
input(2) = 1;
arguments = rand(input(3), 300);
full_connection2 = mFullConnection(input, arguments);

% softmax
input = [1, 1, 300];
softmax = mSoftMax(input);

% net
net = struct('conv1', conv1);                                            %...
%             'max_pool', max_pool,                                       ...
%             'full_connection1', full_connection1,                       ...
%             'full_connection2', full_connection2,                       ...
%             'softmax', softmax);


% Try Forward
estiRes = mForward(net, inputArray);
ss = 'Frame SUCCESS!';
disp(ss);





