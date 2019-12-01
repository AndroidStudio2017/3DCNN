clear
clc
close all

%% video
% video = VideoReader('./video/test.mp4');

% nFrames = video.NumberOfFrames
% height = video.Height
% width = video.Width

% im = read(video, 1);
% imshow(im);

%% struct

% employee.name = 'Johnson';
% employee.age = 19;
% employee.father = 'Mr. Wang';
% 
% fields = fieldnames(employee)
% for i = 1:length(fields)
%     k = fields(i);
%     key = k{1};
%     value = employee.(key);
%     
%     value
%     disp('-----')
% end

%% test for 
for i = 3:-1:1
    disp(i);
end
disp('ff');