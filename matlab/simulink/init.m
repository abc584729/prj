clc, clear, close all;

fs = 15.36e9;       % 采样频率:15.36GHZ
sps = 4;            % 过采样倍数
Rs = fs/sps;        % 符号速率
M = 2;              % 比特/符号
Rb = Rs*M;          % 比特速率
sampleDepth = 6;    % 采样深度
span = 2;           % 滤波器跨度
beta = 0.5;         % 滚降系数

batchSize = 768/sampleDepth/sps*M;

h = rcosdesign(beta, span, sps, 'normal');  % 升余弦滤波器
h = h/max(h);   % 系数归一化
delay = span/2*M;

EbN0 = 100;     % 信噪比
pamPower = mean([-3 -1 1 3].^2);
signalPower = pamPower/sps*sum(abs(h).^2);  % 信号功率

channelCoeffs = [0.7,-0.2,0.1,0.3,0.2,-0.1];     % 多径信道
