function match_drawline( I1, match_pt1, I2, match_pt2 )  
%   输入： 图片I1，I1中的匹配点match_pt1
%          图片I2，I2中的匹配点match_pt2  
%	输出： 角点储存数组Result，角点数cnt
%
%	功能：计算 图片I1的角点和角点数
%
 
    [x1, y1]=size(I1);  
    [x2, y2]=size(I2);  
    x = max(x1,x2);  
    Img = zeros(x,y1+y2);  
    Img(1:x1,1:y1)=I1;  
    Img(1:x2,y1+1:y2+y1)=I2;  
    figure;imshow(uint8(Img));  
    for n=1:length(match_pt1)  
        hold on;  
        plot(match_pt1(n,2),match_pt1(n,1),'r+');  
        plot(y1+match_pt2(n,2),match_pt2(n,1),'r+');  
        S=[match_pt1(n,2),y1+match_pt2(n,2)];  
        T=[match_pt1(n,1),match_pt2(n,1)];  
        line(S,T);  
    end  
    title( '角点匹配');
    legend( 'Matched points 1','Matched points 2');
    hold off;  
end  