function [panorama_pic] =create_panorama(tforms,imageSize,x_lim,y_lim,I1,I2,I3)
%   输入： I1,I2,I3：三幅RGB图片，
%           tforms：对应的tforms对象数组
%           x_lim：x方向的限制，
%           y_lim：y方向的限制
%           
%	输出： panorama_pic：全景图
%
%	功能：根据tforms进行投影变换，生成全景图
%       



    %算变换之后最大最小的限制
    x_Min = min([1; x_lim(:)]);
    x_Max = max([imageSize(2); x_lim(:)]);

    yMin = min([1; y_lim(:)]);
    yMax = max([imageSize(1); y_lim(:)]);

    %取全景图的长宽
    width  = round(x_Max - x_Min);
    height = round(yMax - yMin);

    %创建空的全景图，都取默认值
    panorama_pic = zeros([height width 3], 'like', I1);
    blender_pic = vision.AlphaBlender('Operation', 'Binary mask', ...
        'MaskSource', 'Input port');

    % 创建全景图的2D参考图
    xLimits = [x_Min x_Max];
    yLimits = [yMin yMax];
    perspective = imref2d([height width], xLimits, yLimits);

    %开始生成全景图，现在对RGB图进行操作
    I1 = imread('1.jpg');
    % I1进行变换
    warped_pic = imwarp(I1, tforms(1), 'OutputView', perspective);

    % 生成一个mask,用作覆盖
    warped_mask = imwarp(ones(size(I1(:,:,1))), tforms(1), 'OutputView', perspective);

    % 生成二值图像
    warped_mask = warped_mask >= 1;

    
    % 把转换后的图像覆盖在全景图上
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
    
     I2 = imread('2.jpg');
     for i=1:3
         I2(:,:,i)=I2(:,:,i)+10;
     end
    
    % I2进行变换
    warped_pic = imwarp(I2, tforms(2), 'OutputView', perspective);

    % 生成一个mask,用作覆盖
    warped_mask = imwarp(ones(size(I2(:,:,1))), tforms(2), 'OutputView', perspective);

    % 生成二值图像
    warped_mask = warped_mask >= 1;

    % 把转换后的图像覆盖在全景图上
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
    
     I3 = imread('3.jpg');
     for i=1:3
         I3(:,:,i)=I3(:,:,i)+15;
     end
     % I3进行变换
    warped_pic = imwarp(I3, tforms(3), 'OutputView', perspective);
      

    warped_mask = imwarp(ones(size(I1(:,:,1))), tforms(3), 'OutputView', perspective);

    % 生成一个mask,用作覆盖
    warped_mask = warped_mask >= 1;

    % 把转换后的图像覆盖在全景图上
    panorama_pic = step(blender_pic, panorama_pic, warped_pic, warped_mask);
end



