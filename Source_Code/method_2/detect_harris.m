function [ result,cnt] = detect_harris( I1,threshold )  
%   输入： 图片I1，选取角点的阈值threshold，一般取0.01~0.05
%           
%	输出： 角点储存数组Result，角点数cnt
%
%	功能：计算 图片I1的角点和角点数
%


%R=det(M)-k.*tr(M).^2 经验参数是k=0.04~0.06 这里取k=0.04  
[m,n]=size(I1);  
origin_img=I1;  
img_double=double(I1);  
h=[-2 -1 0 1 2];  
%计算图像亮度f(x,y)在点(x,y)处的梯度
Ix=filter2(h,img_double);  % x方向的梯度  
Iy=filter2(h',img_double); % y方向的梯度



%构造自相关矩阵
Ixx=Ix.^2;  
Iyy=Iy.^2;  
Ixy=Ix.*Iy; 

Gauss=fspecial('gaussian',[7 7],2);  %高斯函数,窗口大小7*7,sigma=2  
Ixx=filter2(Gauss,Ixx);  
Iyy=filter2(Gauss,Iyy);  
Ixy=filter2(Gauss,Ixy);  

%计算矩阵M
k=0.06;                 
Mdet=Ixx.*Iyy-Ixy.^2;   
Mtr=Ixx+Iyy;          
R=Mdet-k.*Mtr.^2;  


%固定阈值，当R(i, j) > T时，则被判定为候选角点
T=threshold*max(R(:));  
result=zeros(m,n);  
  
%在候选角点中进行局部非极大值抑制
cnt=0;  
for i=2:m-1  
    for j=2:n-1  
        %窗口大小3*3的局部非极大值抑制
       if (R(i, j) > T &&...
           R(i, j) > R(i-1, j-1) && R(i, j) > R(i-1, j) && R(i, j) > R(i-1, j+1) &&...
           R(i, j) > R(i, j-1) &&  R(i, j) > R(i, j+1) &&...
           R(i, j) > R(i+1, j-1) && R(i, j) > R(i+1, j) && R(i, j) > R(i+1, j+1))  
            %result矩阵中为1的即为角点
            result(i,j)=1;  
            %统计角点数
            cnt=cnt+1;  
        end;  
    end;  
end;  

end 