function MyTestMatrix = NoWall ()
h = 250;
w = 400;
img_num = 200;
MyTestMatrix = zeros(h,w,img_num);
    for i=1:img_num
        MyTestMatrix(101:200,max(1,i-50):min(i+50,w),i) = 255*ones(100,1 + min(i+50,w) - max(1,i-50));
    end
end
