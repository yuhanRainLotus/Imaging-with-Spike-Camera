% 对于\data目录下的所有数据，调用RawtoSpike，采用特定方法生成视频后保存至对应路径

h=250; w=400;  % 脉冲帧的当前分辨率(宽400 高250)
approach = 'SlidingWindow';
datalist = dir('.\data');
for dir = 3:length(datalist)
    disp(dir);
    dataname = datalist(dir).name;
    fid = fopen(strcat('.\data\',dataname), 'rb');
    if exist(strcat('.\result\',dataname(1:length(dataname)-4)),'dir') == 0
        mkdir(strcat('.\result\',dataname(1:length(dataname)-4)));
    end
    po = exist(strcat('.\result\',dataname(1:length(dataname)-4),'\',approach),'dir');
    if exist(strcat('.\result\',dataname(1:length(dataname)-4),'\',approach),'dir') == 0
        mkdir(strcat('.\result\',dataname(1:length(dataname)-4),'\',approach));
    end
    len_vec = [1,2,4,8,16];
    video_seq = fread(fid, 'uint8'); 
    for ver = 1:length(len_vec)
        half_window_length = len_vec(ver);
        SpikeMatrix = RawtoSpike(video_seq, h, w, half_window_length);
        n = size(SpikeMatrix,3);
        vedio = VideoWriter(strcat('.\result\',dataname(1:length(dataname)-4),'\',approach,'\',dataname(1:length(dataname)-4),approach,'(hwl=' ,num2str(len_vec(ver)),').avi')); %初始化一个avi文件
        vedio.FrameRate = 5;
        open(vedio);
        for i=1: n
            SpkImage = SpikeMatrix(:,:,i);
            writeVideo(vedio,uint8(SpkImage));
        end
        close(vedio);
    end
end
