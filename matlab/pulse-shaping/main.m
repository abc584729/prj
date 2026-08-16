clc, clear, close all;

% 参数配置
fs = 15.36e9;   % 采样频率:15.36GHZ
sps = 4;        % 过采样倍数
Rs = fs/sps;    % 符号速率
span = 2;       % 滤波器跨度
beta = 0.5;     % 滚降系数

% pam4调制
DataL = 1e4;
a = 2*randi([0,3], 1, DataL)-3;

% 升余弦滤波器
h = rcosdesign(beta, span, sps, 'normal');
h = h/max(h);   % 系数归一化

% 成型滤波
s = upsample(a, sps);                       % 上采样
s = filter(h, 1, [s, zeros(1, span/2*sps)]);% 滤波
s = s(span/2*sps+1:end);                    % 滤波器延迟补偿

% 绘图
subplot(211);
length = 10;
ta = 1e9*(0:length-1)/Rs;
ts = 1e9*(0:length*sps-1)/fs;
stem(ta, a(1:length), 'kx');hold on;
plot(ts, s(1:length*sps), 'b-');hold off;
yticks([-3,-1,1,3]);
xlabel('时间 (ns) ');ylabel('幅度');
legend('符号序列', '成形滤波', 'Location', 'southeast');
title('时域波形(前10个符号)');
subplot(212);
[pxx,f] = pwelch(s, 1000, 500, 1024, fs);
plot(f/1e9, pow2db(pxx));
xlabel('Frequency (GHz) ');
ylabel('PSD (dB/Hz) ');
title('功率谱密度');