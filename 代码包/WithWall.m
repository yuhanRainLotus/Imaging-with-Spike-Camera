function MyTestMatrix = WithWall (h,w,img_num)
MyTestMatrix = zeros(h,w,img_num);
    for i=1:img_num
        MyTestMatrix(101:200,max(1,i-50):min(i+50,w),i) = 255*ones(100,1 + min(i+50,w) - max(1,i-50));
    end
    for i=1:img_num
        MyTestMatrix(51:250,51:200,i) = 108*ones(200,150);
    end
end
