function [tforms] =find_center_picture(tforms,x_lim)
%   输入：tforms：原tforms对象数组，
%           x_lim：x方向的限制
%
%	输出：新tforms对象数组
%
%	功能：根据变换后的位置，找到位于中心的图片，
%       根据中心图片的序号，对tform矩阵进行变换；
%       使得中间的图不变，两边的图相对中间进行投影变换。

    %取x的中值
    avgXLim = mean(x_lim, 2);    

    %取按x排序的顺序
    [~, idx] = sort(avgXLim);   

    %取中心图片的序号
    centerIdx = floor((numel(tforms)+1)/2);

    %根据中心图片的序号，对tform矩阵进行变换
    centerImageIdx = idx(centerIdx);
    Tinv = invert(tforms(centerImageIdx));

    %每个都乘以中心图片tform矩阵的逆，结果是中心图片不变，其它图片以中心图片做
    %矩阵变换
    for i = 1:numel(tforms)
    tforms(i).T = Tinv.T * tforms(i).T;
    end
end