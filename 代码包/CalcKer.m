function kernel = CalcKer(window_length)
sigma = double(window_length / 3);
kernel = zeros(1,2*window_length + 1);
sum = 0;
kernel(window_length + 1) = exp(0);
sum = exp(0);
for i = 1:window_length
    kernel(window_length + 1 + i) = exp(-i*i/(2*sigma*sigma));
    kernel(window_length + 1 - i) = exp(-i*i/(2*sigma*sigma));
    sum = sum + 2*exp(-i*i/(2*sigma*sigma));
end
kernel = kernel / sum;
end

