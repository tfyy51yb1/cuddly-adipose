% function histogram = calc_foreground_histogram(img, mask)
% This function calculates a histogram of foreground values in a
% multi-channel image, with a foreground specified by mask.
%
% INPUT
% img       multi-channel image
% mask      logical mask of pixels for which to calculate histogram
%
% OUTPUT
% histogram     Nx1 matrix of histogram values 
%               (N is equal to the image size along dimension 3)
%
% Marcus Wallenberg, 2015
function histogram = calc_foreground_histogram(img, mask)

histogram = zeros(size(img, 3), 1);

for k=1:size(img, 3)
    ch = img(:,:,k);
    
    histogram(k, 1) = mean(ch(mask));
end

histogram = histogram/sum(histogram);