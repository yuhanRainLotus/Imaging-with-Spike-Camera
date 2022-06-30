%输出脉冲矩阵(3维)：帧高、帧宽、帧数
function ff = fastflow(h,w,img_num, SpikeMatrix,ImporvedSpikeMatrix)%最后一项是计算flow使用的matrix，越好的matrix计算越准确

SpikeMatrix = double(255 * SpikeMatrix);
ff=SpikeMatrix;
ret = ImporvedSpikeMatrix;
ex=20;%ex为初始计算flow的间隔时间

half_window_length=calcHWL(img_num,ImporvedSpikeMatrix,ex);%calcHWL为通过计算视频中最大运动速度来确定最优的窗口长度，并据此计算最优间隔时间
seperate=1;%seperate为分离值,已调整完成，为最优值
%for t = 3500:3500%时间，调小可以加快计算，下方是总时间
for t=half_window_length+2:img_num-half_window_length-2
    flow_forward = calc_flow(ret,t,t+ex);
    flow_backward = calc_flow(ret,t,t-ex);
    flow_forward = normalize(flow_forward,seperate);%这是一个稀疏化函数，seperate为分离值，比seperate小的设置为0，比它大的设置为原值。
    flow_backward = normalize(flow_backward,seperate);
    ju = judge(flow_forward,flow_backward);%这是判断是否为被覆盖点的函数，当这点被判断为即将被覆盖（刚从覆盖中走出），它会返回(1,1),(0,2)或是（2，0）



    %矩阵整体运算优化
    for k = 1:half_window_length
       v1_matrix = new_loc(flow_forward(:,:,1)*k/ex,(1:w),w);
       u1_matrix = new_loc(flow_forward(:,:,2)*k/ex,transpose((1:h)),h);
       v2_matrix = new_loc(flow_backward(:,:,1)*k/ex,(1:w),w);
       u2_matrix = new_loc(flow_backward(:,:,2)*k/ex,transpose((1:h)),h);
       ff(:,:,t) = ff(:,:,t)+ju(:,:,1).*MatrixIdx(SpikeMatrix(:,:,t+k),u1_matrix,v1_matrix)+ju(:,:,2).*MatrixIdx(SpikeMatrix(:,:,t-k),u2_matrix,v2_matrix);
    end
end
for t=1:half_window_length+1
    flow_forward = calc_flow(ret,t,t+ex);
    flow_forward = normalize(flow_forward,seperate);  
    for k = 1:half_window_length    
       v1_matrix = new_loc(flow_forward(:,:,1)*k/ex,(1:w),w);
       u1_matrix = new_loc(flow_forward(:,:,2)*k/ex,transpose((1:h)),h);       
       ff(:,:,t) = ff(:,:,t)+2*MatrixIdx(SpikeMatrix(:,:,t+k),u1_matrix,v1_matrix);
    end
end

for t=img_num-half_window_length-1:img_num
    flow_backward = calc_flow(ret,t,t-ex);    
    flow_backward = normalize(flow_backward,seperate);
    for k = 1:half_window_length
           v2_matrix = new_loc(flow_backward(:,:,1)*k/ex,(1:w),w);
           u2_matrix = new_loc(flow_backward(:,:,2)*k/ex,transpose((1:h)),h);
           ff(:,:,t) = ff(:,:,t)+2*MatrixIdx(SpikeMatrix(:,:,t-k),u2_matrix,v2_matrix);
    end 

end
ff = ff/(2*half_window_length+1);
ff = uint8(ff);


end


function hwl=calcHWL(img_num,ImporvedSpikeMatrix,ex)
t=floor(img_num/2);
flow_forward = calc_flow(ImporvedSpikeMatrix,t,t+ex);
speed=max(max(max(flow_forward)))/ex;
hwl=min(max(floor(16/speed),16),64);
end



function r = new_loc(a,b,d)
r = round(min(max(a+b,1),d));
end

function flow = calc_flow(Matrix,t1,t2)
A1=Matrix(:,:,t1);
B1=cat(3,A1,A1,A1);
A2=Matrix(:,:,t2);
B2=cat(3,A2,A2,A2);
im1 = double(B1);
im2 = double(B2);
flow = mex_OF(im1,im2);
end

function a=normalize(flow,seperate)
a=flow;
a(:,:,:)=sign(flow(:,:,:)).*max((abs(flow(:,:,:))-seperate),0).*(abs(flow(:,:,:))./(abs(flow(:,:,:))-seperate));
end

function j = judge(a,b)
j = zeros(250,400,2);
j(:,:,1)=1-abs(sign(a(:,:,1)))+abs(sign(b(:,:,1)));
j(:,:,2)=2-j(:,:,1);
%j(:,:,1)=1;
%j(:,:,2)=1;
end

function ret = MatrixIdx(A,x,y)
size_A = size(A);
ret = A(x + (size_A(1))*(y-1));
end

