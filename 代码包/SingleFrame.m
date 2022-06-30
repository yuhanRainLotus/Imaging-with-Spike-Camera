% 调用RawtoSpike生成单帧图片、播放并保存
% 请修改img_idx来选定帧
% 请修改pic_name来为保存的图片命名

h=250; w=400;  % 脉冲帧的当前分辨率(宽400 高250)
img_idx = 60;
pic_name = '60';
fid =fopen('.\data\number-rotation_short.dat', 'rb');

video_seq = fread(fid, 'uint8'); 
SpikeMatrix = RawtoSpike(video_seq, h, w, 4);

SpkImage = SpikeMatrix(:,:,img_idx);
figure(1); imshow(uint8(SpkImage)); 
imwrite(uint8(SpkImage),strcat(pic_name,'.jpg'),'jpg');
title(['frame ' num2str(img_idx)]);
drawnow;