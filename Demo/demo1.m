clc
clear
close all
addpath(genpath('../3dCNN'))                % ������ļ�����·��
addpath(genpath('../utils'))

%% ��������
minW = 320;
minH = 240;

nFrames = 10;
height = minH;
width = minW;

%% ���� net
% �����
% ����������ʼ��
fm = 8;                                    % ����˸���
fSize = [5, 5, 5];                          % ����˴�С (fh, fw, fn, fm)

input = [height, width, nFrames*3];
filter = 0.001 * randn(fSize(1), fSize(2), fSize(3), fm);
strides = [1, 1, 1];
learning_rate = 0.001;
conv1 = mConv3dbyChannels(input, filter, strides, learning_rate);  

% �ػ���   ** �ػ��߽�ֱ�Ӳ�����
input(1) = floor((height - fSize(1))/strides(1)) + 1;
input(2) = floor((width - fSize(2))/strides(2)) + 1;
input(3) = fm * 3 * floor((nFrames - fSize(3))/strides(3) + 1);
ksize = [3, 3];
max_pool = mPool(input, ksize, 'max_pool');

% ȫ���Ӳ�  ** ���ӳػ����ȫ���Ӳ�ĵط�����ʵ���ʻ���һ�������
input(1) = floor((input(1) - ksize(1))/ksize(1)) + 1;
input(2) = floor((input(2) - ksize(2))/ksize(2)) + 1;
filter = 0.001 * randn(input(1), input(2), 1, 1);
strides = [1, 1, 1];
% learning_rate = 1;
full_connection1 = mConv3d(input, filter, strides, learning_rate);

% ȫ���Ӳ�
input(1) = 1;
input(2) = 1;
arguments = 0.001 * randn(300, input(3));
% arguments = rand(300, input(3));
bias = randn(300, 1);                % ƫ�õ�ά��Ӧ���Ǻ������ά����ͬ
                                    % ӡ�����ǵ�...
% learning_rate = 1;
full_connection2 = mFullConnection(input, arguments, bias, learning_rate);

% ReLU
input = [300, 1];
relu1 = mReLU(input);

% ȫ���Ӳ�
input = [300, 1];
arguments = 0.001 * randn(1024, 300);
bias = randn(1024, 1);
% learning_rate = 1;
full_connection3 = mFullConnection(input, arguments, bias, learning_rate);

% Dropout��
dropout_p = 0.5;
dropout = mDropout(input, dropout_p);

% ReLU
input = [1024, 1];
relu2 = mReLU(input);

% ȫ���Ӳ�
input = [1024, 1];
arguments = 0.001 * randn(2, 1024);
bias = randn(2, 1);
% learning_rate = 1;

full_connection4 = mFullConnection(input, arguments, bias, learning_rate);

% softmax
input = [2, 1];
softmax = mSoftMax(input);  

% net
net = struct('conv1', conv1,                                            ...
            'max_pool', max_pool,                                       ...
             'full_connection1', full_connection1,                      ...
             'full_connection2', full_connection2,                      ...
             'relu1', relu1,                                            ...
             'full_connection3', full_connection3,                      ...
             'dropout', dropout,                                        ...
             'relu2', relu2,                                            ...
             'full_connection4', full_connection4,                      ...
             'softmax', softmax);

% iterate
folder = '../../video/Total/';
namelist = dir('../../video/Total/*.mp4');

len = length(namelist);
% ����ѵ������˳��
randIndex = randperm(len);
namelist = namelist(randIndex);

error_total = [];
for epoch=1:len
    file_name = namelist(epoch).name;
    
    fprintf('��Ƶѵ��: %d\n', epoch);
    fprintf('%s\n\n', file_name);

    real_label = zeros(2, 1);
    % �����ļ�������ʵ��ǩ
    if strfind(file_name, 'truth')
        real_label = [1;0];
    elseif strfind(file_name, 'lie')
        real_label = [0;1];
    else
        error('[ERROR] File name have not "truth" or "lie".');
        break;
    end
    
    % ��ȡ��Ƶ����
    fprintf('��ȡ��Ƶ���� ...\n');
    videoRaw = VideoReader([folder, file_name]);
    
    % ������������
    fprintf('����RGBͨ�� ...\n');
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
    inputArray = uint8(cat(3, img_R, img_G, img_B));
    
    % ǰ�򴫲�
    fprintf('ǰ�򴫲��� ...\n');
    estiRes = mForward(net, inputArray);
    
    % Loss
    error = mLoss(estiRes, real_label);
    error_total = [error_total, error];
    fprintf('��������ʧ�������: %f\n', error);
    
    % BP
    fprintf('���򴫲��� ...\n')
    mBackward(net, real_label);
end

