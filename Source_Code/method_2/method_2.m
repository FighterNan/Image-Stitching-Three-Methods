% 运行时，请先打开create_panorama，transfer_caculate，ncc_caculate，detect_harris
%                imfreqfilt, imggaussflpf等四个头文件

% *************************
% image sitching method_2
% *************************


clear all;
clc;

I1=imread('1.jpg');
I1_gray=rgb2gray(I1);

%探测Harris角点
[ I1_Harris,I1_cnt] = detect_harris(I1_gray,0.1);

  
%画出I1角点
[r_1,c_1]=find(I1_Harris==1);  
figure;  
imshow(I1);  
hold on;  
text(c_1,r_1,'*','FontSize',8,'color','r');
title('I1角点');
impixelinfo;

I2=imread('2.jpg');
I2_gray=rgb2gray(I2);

%探测Harris角点
[ I2_Harris,I2_cnt] = detect_harris(I2_gray,0.1);

  
%画出I2角点
[r_2,c_2]=find(I2_Harris==1);  
figure;  
imshow(I2);  
hold on;  
text(c_2,r_2,'*','FontSize',8,'color','r');
title('I2角点');
impixelinfo;

%I1、I2的角点匹配
[ match_pt1,match_pt2 ] = harris_match( I1_gray,I2_gray,I1_Harris,I2_Harris,I1_cnt,I2_cnt);   
  
%选出3:6的匹配角点
movingPoints=match_pt1(3:6,:);
fixedPoints=match_pt2(3:6,:);

%画线，连起匹配角点
match_drawline( I1_gray,match_pt1(3:6,:), I2_gray, match_pt2(3:6,:) ); 

I3=imread('3.jpg');
I3_gray=rgb2gray(I3);

%探测Harris角点
[ I3_Harris,I3_cnt] = detect_harris(I3_gray,0.2);

%画出I3角点
[r_3,c_3]=find(I3_Harris==1);  
figure;  
imshow(I3);  
hold on;  
text(c_3,r_3,'*','FontSize',8,'color','r');
title('I3角点');
impixelinfo;

%I3、I2的角点匹配
[ match_pt3,match_pt4] = harris_match( I3_gray,I2_gray,I3_Harris,I2_Harris,I3_cnt,I2_cnt);   

%画线，连起匹配角点
match_drawline( I2_gray, match_pt4, I3_gray, match_pt3 );  
movingPoints=[218,234;268,234;171,317;231,323];
fixedPoints=[84,239;131,241;25,330;89,331];
fixedPoints1=[184,152;216,152;216,329;280,328];
movingPoints1=[25,121;60,127;39,305;102,300];
imageSize=size(I1);


%生成透视矩阵
T1=transfer_caculate(movingPoints, fixedPoints);
T2=transfer_caculate(movingPoints1, fixedPoints1);


tforms(3) = projective2d(eye(3));

% T=maketform('projective',T1);   %透视矩阵
% [I X Y]=imtransform(I1,T);     %透视
% figure;
% imshow(I);


%用变换矩阵赋值tform对象
tforms(1).T=T1;
tforms(3).T=T2;


%重新计算变换之后的限制
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

%算变换之后最大最小的限制
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

%取全景图的长宽
width  = round(xMax - xMin);
height = round(yMax - yMin);

%创建空的全景图，都取默认值
panorama = zeros([height width 3], 'like', I1);
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% 创建全景图的2D参考图
xLimits = [xMin xMax];
yLimits = [yMin yMax];
perspective = imref2d([height width], xLimits, yLimits);


I1 = imread('1.jpg');
   % I1进行变换
pic_I1 = imwarp(I1, tforms(1), 'OutputView', perspective);
I2 = imread('2.jpg');

   % I2进行变换
pic_I2 = imwarp(I2, tforms(2), 'OutputView', perspective);
I3 = imread('3.jpg');
  % I3进行变换
pic_I3 = imwarp(I3, tforms(3), 'OutputView', perspective);

%取A-B的部分
for i=1:260
    for j=1:height
        panorama(j,i,:)=pic_I1(j,i,:);
    end
end
figure;
imshow(panorama);

%取B的全部
for i=260:874
    for j=1:height
        panorama(j,i,:)=pic_I2(j,i,:);
        panorama(j,i,:)=panorama(j,i,:)+10;
    end
end
figure;
imshow(panorama);

%取C-B的全部
for i=506:815
    for j=1:height
        panorama(j,i,:)=pic_I3(j,i,:);
    end
end

figure;
imshow(panorama);
title('全景图');
for i=1:3
    % 高斯函数的频域低通滤波，以提高图像光滑度
    
    % 生成sigma=200的高斯函数
    ff = creat_gauss(panorama(:,:,i),150);
    
    % 频域低通滤波
    out = lowpass_freq_filt(panorama(:,:,i), ff);
    panorama(:,:,i)=out;
end

figure;
imshow(panorama);
title('频域低通滤波后的全景图');





