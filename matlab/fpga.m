clc, clear, close all;

% configration
fs = 7.68e9;    % 采样频率:7.68GHZ
sps = 4;        % 过采样倍数:4
Rs = fs/sps;    % 符号速率
span = 2;       % 滤波器跨度
beta = 0.5;     % 滚降系数

% 发射序列
DataL = 32;                      % 符号个数
tx = 1e9 * (0: DataL - 1) / Rs;  % t(ns)
x = randi([0,3], 1, DataL);      % pam4符号(00 01 10 11)

% 升余弦滤波器
%h = rcosdesign(beta, span, sps, 'normal');
h = [0,14,31,46,52,46,31,14,0];
mem = round([zeros(1, sps*span+1);h/3;h*2/3;h]);

% 成形滤波
x0 = 0;
ty = 1e9 * (0: DataL*sps - 1) / fs;  % t(ns)
y = zeros(1, DataL*sps);
for i = 0:DataL-1
  if i == 0 
    y(1) = mem(x0+1, 5)+mem(x(i+1)+1, 9);
    y(2) = mem(x0+1, 4)+mem(x(i+1)+1, 8);
    y(3) = mem(x0+1, 3)+mem(x(i+1)+1, 7);
    y(4) = mem(x0+1, 2)+mem(x(i+1)+1, 6);
  else 
    y(i*sps+1) = mem(x(i)+1, 5)+mem(x(i+1)+1, 9);
    y(i*sps+2) = mem(x(i)+1, 4)+mem(x(i+1)+1, 8);
    y(i*sps+3) = mem(x(i)+1, 3)+mem(x(i+1)+1, 7);
    y(i*sps+4) = mem(x(i)+1, 2)+mem(x(i+1)+1, 6);
  end
end

% 抽样判决
y_s = y(5:4:end);
x_hat = zeros(1, DataL-1);
threshold = [9, 26, 44];
for i=1:DataL-1
  if y_s(i) < threshold(1)
      x_hat(i) = 0;
  elseif y_s(i) < threshold(2)
      x_hat(i) = 1;
  elseif y_s(i) < threshold(3)
      x_hat(i) = 2;
  else
      x_hat(i) = 3;
  end
end

% 误码统计
bit_error = sum(x_hat~=x(1:end-1));
disp(bit_error);