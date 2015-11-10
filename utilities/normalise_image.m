% function img = normalise_image(img)
%
% This function takes a multi-channel image and for each channel normalises
% the value range to [0 1]. It is useful when plotting three-channel images
% that have a different value range as RGB images.
%
% INPUT
% img       image (double precision)
%
% OUTPUT
% img       the same image, each channel normalised to [0 1] 
%
% Marcus Wallenberg, 2015
function img = normalise_image(img)

for k=1:size(img, 3)
    ch = img(:,:,k);
    ch = ch - min(min(ch));
    ch = ch/max(max(ch));
    img(:,:,k) = ch;
end

img(isnan(img)) = 0;
img(isinf(img)) = 0;