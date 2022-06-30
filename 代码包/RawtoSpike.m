% 输出脉冲矩阵(3维)：帧高、帧宽、帧数
function SpikeMatrix = RawtoSpike(video_seq, h, w, half_window_length)
video_seq = uint8(video_seq);
len = length(video_seq);
disp(len)
img_num = len / (h*w/8);
SpikeMatrix = zeros(h, w, img_num, 'uint8');

pix_id = reshape((1:h*w), w, h)'; %每帧像素的序号矩阵，转置是因为matlab默认按列排而原始数据按行排
comparator = bitshift(uint8(1), uint8(mod(pix_id-1, 8)));
byte_idx = floor((pix_id+7)/8);

for img_id = 1:img_num
    id_start = (img_id-1)*(h*w/8) + 1;
    id_end = img_id*(h*w/8);
    cur_info = video_seq(id_start:id_end);
    data = cur_info(byte_idx);
    result = bitand(data, comparator);
    SpikeMatrix(:,:,img_id) = flipud((result == comparator)); %水平翻转是因为脉冲相机拍出来的是倒向
end
%SpikeMatrix = SlidingWindow(half_window_length,h,w,img_num,SpikeMatrix);
SpikeMatrix1 = WeightSpikeMatrix(half_window_length,h,w,img_num,SpikeMatrix);
%SpikeMatrix = Naive(h,w,img_num,SpikeMatrix);
%SpikeMatrix = SmoothMatrix(h,w,img_num,SpikeMatrix);
SpikeMatrix = fastflow(h,w,img_num,SpikeMatrix,SpikeMatrix1);
SpikeMatrix =imresize(SpikeMatrix,2,'bilinear');%已经进行过调试，对比后使用bilinear最好，
%SpikeMatrix = kernel_regression(half_window_length,h,w,img_num,SpikeMatrix);
end