function [ match_pt1,match_pt2 ] = harris_match( I1_gray,I2_gray,I1_Harris,I2_Harris,I1_cnt,I2_cnt) 
%   输入： I1_gray：图片I1；
%           I2_gray：图片I2；
%           I1_Harris：图片I1的角点矩阵；
%           I2_Harris：图片I2的角点矩阵；
%           I1_cnt：I1的角点数；
%           I2_cnt：I2的角点数；
%           
%	输出： match_pt1：I1中匹配角点的x,y；
%           match_pt2：I2中匹配角点的x,y；
%
%	功能：匹配I1和I2的角点
%

%取出harris角点
[r1,c1]=find(I1_Harris==1);  
[r2,c2]=find(I2_Harris==1);  
point1=[r1 c1];  
point2=[r2 c2];
temp_point2=zeros(size(point1));  

%创建ncc矩阵
ncc=zeros(I1_cnt,I2_cnt); 

k=5;  

%扩大边界
I1_extend = pic_extend(I1_gray,k);  
I2_extend = pic_extend(I2_gray,k);  
  
%计算
for i=1:I1_cnt  
    p = point1(i,1)+k;
    q = point1(i,2)+k;  
    
    %创建I1角点周围11*11的窗
    windows1 = I1_extend(p-5:p+5,q-5:q+5);   
    for j=1:I2_cnt  
        m = point2(j,1)+k;
        n = point2(j,2)+k;   
        
         %创建I2角点周围11*11的窗
        windows2 = I2_extend(m-5:m+5,n-5:n+5);
        
        %计算归一化交叉相关相似度
        ncc(i,j) = ncc_caculate(windows1,windows2); 
        
    end     
    
    % ncc_max是每一列的最大值
    ncc_max=max(ncc(i,:));   
    [r,c]=find(ncc(i,:)==ncc_max); 
    ncc(ncc==ncc_max)=0;  
    ncc_now=max(ncc(i,:));
    
    % ncc_max是每一列的最大值
    threshold=double(ncc_now/ncc_max); 
    
    if threshold<0.8 
      % 若小于0.8则匹配
      temp_point2(i,:)=point2(c,:);    
    else  
      % 否则记为0
      temp_point2(i,:)=0;  
    end;         
end;  

% 匹配总点数
cnt_match=numel(temp_point2,temp_point2~=0)/2;  

% 创建匹配矩阵
match_pt1=zeros(cnt_match,2);  
match_pt2=zeros(cnt_match,2);  
j=1;  

% 存储匹配结果
for i=1:I1_cnt  
    if((temp_point2(i,1)~=0)&&(point1(i,1)~=0))  
        match_pt2(j,:)=temp_point2(i,:);          
        match_pt1(j,:)=point1(i,:);  
        j=j+1;      
    end;  
end;  
end  