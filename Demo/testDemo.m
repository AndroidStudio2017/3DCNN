clc
clear
close all
addpath(genpath('../3dCNN'))                % 加入库文件搜索路径
addpath(genpath('../utils'))

%% 读取视频数据
videoRaw = VideoReader('../../video/Truthful/trial_truth_002.mp4');

nFrames = 10;
height = videoRaw.Height;
width = videoRaw.Width;

%% 构成网络输入
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

%% 构建 net
% 卷积层
% 卷积核随机初始化
fm = 8;                                    % 卷积核个数
fSize = [5, 5, 5];                          % 卷积核大小 (fh, fw, fn, fm)

input = [height, width, nFrames*3];
filter = 0.001 * randn(fSize(1), fSize(2), fSize(3), fm);
strides = [1, 1, 1];
learning_rate = 0.001;
conv1 = mConv3dbyChannels(input, filter, strides, learning_rate);  

% 池化层   ** 池化边界直接不处理
input(1) = floor((height - fSize(1))/strides(1)) + 1;
input(2) = floor((width - fSize(2))/strides(2)) + 1;
input(3) = fm * 3 * floor((nFrames - fSize(3))/strides(3) + 1);
ksize = [3, 3];
max_pool = mPool(input, ksize, 'max_pool');

% 全连接层  ** 连接池化层和全连接层的地方，其实本质还是一个卷积层
input(1) = floor((input(1) - ksize(1))/ksize(1)) + 1;
input(2) = floor((input(2) - ksize(2))/ksize(2)) + 1;
filter = 0.001 * randn(input(1), input(2), 1, 1);
strides = [1, 1, 1];
% learning_rate = 1;
full_connection1 = mConv3d(input, filter, strides, learning_rate);

% 全连接层
input(1) = 1;
input(2) = 1;
arguments = 0.001 * randn(300, input(3));
% arguments = rand(300, input(3));
bias = ones(300, 1);                % 偏置的维度应该是和输出的维度相同
                                    % 印象中是的...
% learning_rate = 1;
full_connection2 = mFullConnection(input, arguments, bias, learning_rate);

% ReLU
input = [300, 1];
relu1 = mReLU(input);

% 全连接层
input = [300, 1];
arguments = 0.001 * randn(1024, 300);
bias = ones(1024, 1);
% learning_rate = 1;
full_connection3 = mFullConnection(input, arguments, bias, learning_rate);

% Dropout层
dropout_p = 0.5;
dropout = mDropout(input, dropout_p);

% ReLU
input = [1024, 1];
relu2 = mReLU(input);

% 全连接层
input = [1024, 1];
arguments = 0.001 * randn(2, 1024);
bias = ones(2, 1);
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
truth_folder = '../../video/Truthful/';
decept_folder = '../../video/Deceptive/';
truth_list = dir('../../video/Truthful/*.mp4');
decept_list = dir('../../video/Deceptive/*.mp4');

truth_len = length(truth_list);
decept_len = length(decept_list);

error_total = [];
for epoch=1:10
    
%     % 读取视频数据
%     fprintf('读取视频数据 ...\n');
%     videoRaw = VideoReader([truth_folder, truth_list(1).name]);
%     
%     % nFrames = videoRaw.NumberOfFrames;
%     nFrames = 10;
%     height = videoRaw.Height;
%     width = videoRaw.Width;
%     
%     % 构造网络输入
%     fprintf('分离RGB通道 ...\n');
%     img_R = zeros(height, width, nFrames); 
%     img_G = zeros(height, width, nFrames); 
%     img_B = zeros(height, width, nFrames);
% 
%     for i = 1:nFrames
%         im = read(videoRaw, i);
%         [R, G, B] = separateRGB(im);
%         img_R(:, :, i) = R;
%         img_G(:, :, i) = G;
%         img_B(:, :, i) = B;
%     end
%     inputArray = uint8(cat(3, img_R, img_G, img_B));
    
    % 前向传播
    fprintf('前向传播中 ...\n');
    estiRes = mForward(net, inputArray);
    
    % Loss
    real_label = [1;0];
    error = mLoss(estiRes, real_label);
    error_total = [error_total, error];
    fprintf('交叉熵损失函数结果: %f\n', error);
    
    % BP
    fprintf('反向传播中 ...\n')
    mBackward(net, real_label);
end
