function out = lowpass_freq_filt(I,ff)
%   输入：I：原图像
%          ff：频域滤波器
%
%	输出：out：低通滤波的新图像
%
%	功能：高斯函数的频域低通滤波，以提高图像光滑度

    f = fft2(double(I));

    s = fftshift(f);
    out = s.*ff;
    out = ifftshift(out);
    out = ifft2(out);
    out = real(out);
    %out = out/max(out(:));
end