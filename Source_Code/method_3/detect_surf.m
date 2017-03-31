function [valid_features,valid_points] = detect_surf(I1)
   
    %找I1的特征点
    gray_pic = rgb2gray(I1);        %RGB图转灰度图
    points = detectSURFFeatures(gray_pic); %找surf特征点

    figure;             %在灰度图上画surf特征点
    imshow(gray_pic); 
    hold on;
    points.plot;

    %取有效的特征点，及其周围的信息
    [valid_features, valid_points] = extractFeatures(gray_pic, points);
end
