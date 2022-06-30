function smooth = SmoothMatrix (h,w,img_num,MySpikeMatrix)
hkl = 1; % half kernel length
kernel = [0.08,0.08,0.08;
          0.08,0.36,0.08;
          0.08,0.08,0.08];
MySpikeMatrix = double(MySpikeMatrix);
smooth = zeros(h,w,img_num,'double');
for k = 1:img_num/10
    disp(k);
    smooth(1:h,1,k) = MySpikeMatrix(1:h,1,k);
    smooth(1:h,w,k) = MySpikeMatrix(1:h,w,k);
    smooth(1,1:w,k) = MySpikeMatrix(1,1:w,k);
    smooth(h,1:w,k) = MySpikeMatrix(h,1:w,k);
    for i = 1+hkl:h-hkl
        for j = 1+hkl:w-hkl
            smooth(i,j,k) = sum(sum(kernel .* MySpikeMatrix(i-1:i+1,j-1:j+1,k)));
        end
    end
end
end