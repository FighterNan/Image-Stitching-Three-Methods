% 运行时，请先打开find_center_picture，detect_surf，create_panorama
%               imfreqfilt, imggaussflpf等五个头文件
%               并关闭其他method.m的文件
%               若结果图像较小，请重新运行

% *************************
% image sitching method_3
% *************************

% 初始化投影变换的对象数组tforn
tforms(3) = projective2d(eye(3));

% 读取第一个图像
I1 = imread('1.jpg');

% 找第一个图像的surf有效特征点和有效特征
[valid_features,valid_points] = detect_surf(I1);


% 继续计算I2
    
% 先把I1的特征点和其信息存起来
points_pre = valid_points; 
features_pre = valid_features;
% 读取I2
I2 = imread('2.jpg');

% 找第二个图像的surf有效特征点和有效特征
[valid_features,valid_points] = detect_surf(I2);

% 找I1和I2的相似处,储存在indexPairs矩阵中,其第一列为I2的index，第二行为I2的index
index_match = matchFeatures(valid_features, features_pre, 'Unique', true);

matched_valid_points = valid_points(index_match(:,1), :);
matched_points_pre = points_pre(index_match(:,2), :);
    
%imshow候选的匹配结果
figure; 
ax = axes;
showMatchedFeatures(I2, I1, matched_valid_points, matched_points_pre,...
    'montage', 'Parent',ax);
title(ax, 'Candidate point matches betweem I1 and I2');
legend(ax, 'Matched points 1','Matched points 2');
    
%计算从I2到I1的tform对象
tforms(2) = estimateGeometricTransform(matched_valid_points, matched_points_pre,...
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

% 计算 tforms(2).T
tforms(2).T = tforms(1).T * tforms(2).T;

    
%继续计算I3
        
%先把I2的特征点和其信息存起来
points_pre = valid_points; 
features_pre = valid_features;

% 读取I3
I3 = imread('3.jpg');


% 找第三个图像的surf有效特征点和有效特征
[valid_features,valid_points] = detect_surf(I3);

%找I1和I2的相似处,储存在index_match索引矩阵中,其第一列为I2的index，第二行为I2的index
index_match = matchFeatures(valid_features, features_pre, 'Unique', true);
matched_valid_points = valid_points(index_match(:,1), :);
matched_points_pre = points_pre(index_match(:,2), :);
    
%imshow候选的匹配结果
figure; 
ax = axes;
showMatchedFeatures(I3, I2, matched_valid_points, matched_points_pre,...
        'montage', 'Parent',ax);
title(ax, 'Candidate point matches betweem I2 and I3');
legend(ax, 'Matched points 1','Matched points 2');
    
%计算从I2到I1的tform对象
tforms(3) = estimateGeometricTransform(matched_valid_points, matched_points_pre,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

% 计算 tforms(3).T
tforms(3).T = tforms(2).T * tforms(3).T;


imageSize = size(I1);  %三幅图像大小相同



% 计算投影变换之后每幅图的范围
for i = 1:3
    [x_lim(i,:), y_lim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% 自动找到中间的图片，并更新的tforms
tforms = find_center_picture(tforms,x_lim);

% 生成全景图
panorama_pic = create_panorama(tforms,imageSize,x_lim,y_lim,I1,I2,I3);

figure;
imshow(panorama_pic);
impixelinfo;
for i=1:3
    % 高斯函数的频域低通滤波，以提高图像光滑度
    
    % 生成sigma=200的高斯函数
    ff = creat_gauss(panorama_pic(:,:,i),200);
    
    % 频域低通滤波
    out = lowpass_freq_filt(panorama_pic(:,:,i), ff);
    panorama_pic(:,:,i)=out;
end

figure;
imshow(panorama_pic);
impixelinfo;