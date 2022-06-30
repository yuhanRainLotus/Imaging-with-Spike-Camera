% 输入
%      h: 图片高度
%      w: 图片宽度
%      img_num: 帧数
%      SpikeMatrix: 0-1的uint8类型矩阵序列
%
% 返回
%      NaiveMatrix: 0-255的uint8类型矩阵序列

function NaiveMatrix = Naive(h,w,img_num,SpikeMatrix)
SpikeMatrix = double(SpikeMatrix);
NaiveMatrix = zeros(h, w, img_num, 'double');
for i = 1:h
    for j = 1:w
        s = 1;t = 1;
        count = 0;
        for s = 1:img_num
            if(SpikeMatrix(i,j,s)==1)
                for t = t:s
                    NaiveMatrix(i,j,t) = 255/(count + 1);
                end
                count = 0;
            end
            count = count + 1;
        end
    end
end         
NaiveMatrix = uint8(NaiveMatrix);
end