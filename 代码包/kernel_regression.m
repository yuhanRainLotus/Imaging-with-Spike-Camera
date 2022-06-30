function ker=kernel_regression(wl,h,w,img_num, SpikeMatrix)
H=diag([10,10,10]);
SpikeMatrix = double(255 * SpikeMatrix);
ker=zeros(h, w, img_num, 'double');
s=wl;

for t=60:60
    for i=s:h-s
        for j=s:w-s
            x=[i,j,t];
            W=zeros(s^3,s^3);
            X=zeros(s^3,10);
            y=zeros(s^3,1);
            
            for k=0:s^3-1
                y(k+1)=SpikeMatrix([i+floor(k/(s^2))-(s-1)/2,j+mod(floor(k/s),3)-(s-1)/2,t+mod(k,s)-(s-1)/2]);
                x1=[i+floor(k/(s^2))-(s-1)/2,j+mod(floor(k/s),3)-(s-1)/2,t+mod(k,s)-(s-1)/2];
                X(k+1,:)=[1,(x1-x),vech((x1-x).'*(x1-x))];
                W(k+1,k+1)=1/kernel((x1-x).',H);
            end
            beta=((X.'*W*X)^-1)*X.'*W*y;
            ker(i,j,t)=beta(1);
        end
    end
end
ker= uint8(ker);
end


                
                
                
                

                
                
function v=vech(A)
[m,n]=size(A);
v=zeros((m^2+m)/2,1);
t=1;
for i=1:m
    for j=1:n
        if i<=j
        v(t)=A(i,j);
        t=t+1;
        end
    end
end
v=v.';
end

function K=kernel(x,h)
K=exp(-(((h^-1)*x).'*(h^-1)*x)/2)/det(h);
end
