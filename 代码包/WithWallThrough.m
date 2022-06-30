% 输出黑色背景下缓慢移动，并被灰墙遮挡的贯通白色方块
% 输入
%      h: 图片高度
%      w: 图片宽度
%      img_num: 帧数
% 返回
%      MyTestMatrix: 0-255的uint8类型矩阵序列

function MyTestMatrix = WithWallThrough (h,w,img_num)
MyTestMatrix = zeros(h,w,img_num);
    for i=1:img_num
        MyTestMatrix(1:h,max(1,i-50):min(i+50,w),i) = 255*ones(h,1 + min(i+50,w) - max(1,i-50));
    end
    for i=1:img_num
        MyTestMatrix(51:250,51:200,i) = 108*ones(200,150);
    end
end
