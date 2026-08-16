clc, clear, close all;

% 训练序列(32个符号)
train_seq = [
    0 2 2 1 0 3 2 1 ...
    0 3 1 3 3 0 2 2 ...
    2 3 3 1 2 0 1 1 ...
    0 1 0 3 1 3 2 0
];

% 相关模版(128*6)
DataL = 32; 
sps = 4;
span = 2;

h = [0,14,31,46,52,46,31,14,0];
mem = round([zeros(1, sps*span+1);h/3;h*2/3;h]);

x0 = train_seq(end);
x = train_seq;
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

corr_template = round(y);

% 相关
alpha = 0.5 + 0.5*rand;
s = alpha * y;
s = s/sum(s);
[r, lags] = xcorr(s, corr_template);
stem(lags, r);

% 保存系数
write_mem(train_seq, 2, 'train_sequence_32x2.mem');
write_mem(corr_template, 6, 'corr_template_128x6.mem');

function write_mem(data, bit_width, file_name)
    mem_file = file_name;
    fid = fopen(mem_file,'w');
    for i = 1:length(data) 
        fprintf(fid,'%s\n',dec2bin(data(i),bit_width));
    end
    fclose(fid);
end