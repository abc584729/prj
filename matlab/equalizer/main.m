clc, clear, close all;
h = zeros(1, 16);
write_mem(h, 16, "equalizer.mem");


function write_mem(data, bit_width, file_name)
    mem_file = file_name;
    fid = fopen(mem_file,'w');
    for i = 1:length(data) 
        fprintf(fid,'%s\n',dec2bin(data(i),bit_width));
    end
    fclose(fid);
end