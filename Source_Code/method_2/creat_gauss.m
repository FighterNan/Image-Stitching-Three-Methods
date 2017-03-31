function out = creat_gauss(I, sigma)
%   输入：I：原图像
%          sigma：sigma参数
%
%	输出：out：高斯mask
%
%	功能：生成频域的滤波器

    [M N] = size(I);
    out = ones(M, N);
    for i = 1:M
        for j =1:N 
            out(i,j) = exp (-((i-M/2)^2+(j-N/2)^2)/2/sigma^2);
        end
    end
end