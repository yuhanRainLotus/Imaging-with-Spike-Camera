% 输入 h: 图片高度
%      w: 图片宽度
%      img_num: 帧数
%      SpikeMatrix: 0-255的uint8类型矩阵序列
%      half_window_length: 半窗长

function ret = WeightSpikeMatrix(window_length,h,w,img_num, SpikeMatrix)
kernel = ones(2 * window_length + 1);
SpikeMatrix = double(255 * SpikeMatrix);
ret = zeros(h, w, img_num, 'double');
for i = 1:img_num
    sum = 0;
    for j = max(1,i-window_length):min(img_num,i+window_length)
        ret(:,:,i) = ret(:,:,i) + kernel(j-i+window_length+1)*SpikeMatrix(:,:,j);
        sum = sum + kernel(j-i+window_length+1);
    end
    ret(:,:,i) = ret(:,:,i) / sum;
end
%disp(ret(:,:,33));
ret = uint8(ret);
end
