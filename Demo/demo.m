clc
clear
close all
addpath(genpath('../3dCNN'))                % ������ļ�����·��
addpath(genpath('../utils'))

%% ����һЩ�ɵ����Ĳ���
minW = 320;
minH = 240;

width = minW;
height = minH;

%% ���� net
% �����
% ����������ʼ��
fm = 8;                                    % ����˸���
fSize = [5, 5, 5];                          % ����˴�С (fh, fw, fn, fm)

input = [minH, minW];                       % ����Ҫ֡����ά�ȣ�����CNN��ȫ���ӹ��ɲ�ľ����
filter = 0.001 * randn(fSize(1), fSize(2), fSize(3), fm);
strides = [1, 1, 1];
learning_rate = 1;
conv1 = mConv3dbyChannels(filter, strides, learning_rate);  

% �ػ���   ** �ػ��߽�ֱ�Ӳ�����
input(1) = floor((height - fSize(1))/strides(1)) + 1;
input(2) = floor((width - fSize(2))/strides(2)) + 1;
ksize = [3, 3];
max_pool = mPool(ksize, 'max_pool');

% ȫ���Ӳ�  ** ���ӳػ����ȫ���Ӳ�ĵط�����ʵ���ʻ���һ�������
input(1) = floor((input(1) - ksize(1))/ksize(1)) + 1;
input(2) = floor((input(2) - ksize(2))/ksize(2)) + 1;
filter = 0.001 * randn(input(1), input(2), 1, 1);
strides = [1, 1, 1];
learning_rate = 1;
full_connection1 = mConv3d(filter, strides, learning_rate);

% ȫ���Ӳ�
arguments = 0.001 * randn(300, input(3));
% arguments = rand(300, input(3));
bias = ones(300, 1);                % ƫ�õ�ά��Ӧ���Ǻ������ά����ͬ
                                    % ӡ�����ǵ�...
learning_rate = 1;
full_connection2 = mFullConnection(arguments, bias, learning_rate);

% ReLU
relu1 = mReLU();

% ȫ���Ӳ�
arguments = 0.001 * randn(1024, 300);
bias = ones(1024, 1);
learning_rate = 1;
full_connection3 = mFullConnection(arguments, bias, learning_rate);

% Dropout��
dropout_p = 0.5;
dropout = mDropout(dropout_p);

% ReLU
relu2 = mReLU();

% ȫ���Ӳ�
arguments = 0.001 * randn(2, 1024);
bias = ones(2, 1);
learning_rate = 1;

full_connection4 = mFullConnection(arguments, bias, learning_rate);

% softmax
softmax = mSoftMax();  

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

% Try Forward
% tic
% estiRes = mForward(net, inputArray);
% toc

% Loss
% real_label = [1;0];
% error = mLoss(estiRes, real_label)

% Try Backward
% tic
% delta = mBackward(net, real_label);
% toc

% ss = 'Frame SUCCESS!';
% disp(ss);

% iterate
truth_folder = '../../video/Truthful/';
decept_folder = '../../video/Deceptive/';
truth_list = dir('../../video/Truthful/*.mp4');
decept_list = dir('../../video/Deceptive/*.mp4');

truth_len = length(truth_list);
decept_len = length(decept_list);

for i=1:truth_len
    file_name = truth_list(i).name;
    
    fprintf('\n��Ƶ����: %d\n', i);
    fprintf([file_name, '\n\n']);
    
    % ��ȡ��Ƶ����
    fprintf('��ȡ��Ƶ���� ...\n');
    videoRaw = VideoReader([truth_folder, truth_list(i).name]);
    
    % nFrames = videoRaw.NumberOfFrames;
    nFrames = videoRaw.NumberOfFrames;
    height = videoRaw.Height;
    width = videoRaw.Width;
    
    % ������������
    fprintf('����RGBͨ�� ...\n');
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
    inputArray = uint8(cat(3, img_R, img_G, img_B));
    
    % ǰ�򴫲�
    fprintf('ǰ�򴫲��� ...\n');
    estiRes = mForward(net, inputArray);
    
    % Loss
    real_label = [1;0];
    error = mLoss(estiRes, real_label);
    fprintf('��������ʧ�������: %f', error);
    
    % BP
    fprintf('���򴫲��� ...\n')
    mBackward(net, real_label);
end
