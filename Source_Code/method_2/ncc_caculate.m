function [ ncc ] = ncc_caculate(windows1,windows2 )  
%   输入： 点(i,j)附近的两个11*11的窗口windows1,windows2
%           
%	输出： 点(i,j)的归一化交叉相关相似度ncc
%
%	功能：计算归一化交叉相关相似度
%

    %减去平均值
    N1=windows1-mean(windows1(:));  
    
    %减去平均值
    N2=windows2-mean(windows2(:));  
    
    %计算分子
    M1=sum(sum(N1.*N2));  
    
    %计算分母
    M2=sqrt(sum(sum(N1.^2))*sum(sum(N1.^2)));  
    
    %求归一化相似度
    ncc=abs(M1/M2);    
      
end  