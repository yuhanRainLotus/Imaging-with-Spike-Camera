% 调用RawtoSpike生成视频、播放并保存

h=250; w=400;  % 脉冲帧的当前分辨率(宽400 高250)
fid =fopen('.\data\car-100kmh.dat', 'rb');

video_seq = fread(fid, 'uint8'); 
SpikeMatrix = RawtoSpike(video_seq, h, w, 32);
n = size(SpikeMatrix,3);
vedio = VideoWriter('testSpeed.avi'); %初始化一个avi文件
vedio.FrameRate = 5;
open(vedio);
for i=1: n
    disp(strcat('i = ',num2str(i)));
    SpkImage = SpikeMatrix(:,:,i);
    figure(1); imshow(uint8(SpkImage)); 
    writeVideo(vedio,uint8(SpkImage));
    title(['frame ' num2str(i)]);
    drawnow;
    % pause(0.01);
end
close(vedio);