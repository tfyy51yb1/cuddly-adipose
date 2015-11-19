% function rgbimg = multispect2rgb(multispectimg)
% 
% This function rescales a multispectral image to a three-channel
% false-colour RGB image. Each colour channel is normalised to [0 1].
% The spectral axis is arbitrary and has no meaning. 
% However, it may be useful for visualisation in debugging.
%
% INPUT
% multispectimg MxNxD multispectral image
%
% OUTPUT
% rgbimg        

function rgbimg = multispect2rgb(multispectimg)

info = whos('multispectimg');
if ~strcmp(info.class, 'double') || ~strcmp(info.class, 'uint8')
    multispectimg = im2double(multispectimg);
end

multispectimg = permute(multispectimg, [3 1 2]);

rgbimg = imresize(multispectimg, [3, size(multispectimg, 2)], 'bicubic');

rgbimg = permute(rgbimg, [2 3 1]);

for k=1:size(rgbimg, 3)
    ch = rgbimg(:,:,k);
    ch = ch - min(min(ch));
    sfac = max(max(ch));
    if sfac > 0
        ch = ch/sfac;
    end
    rgbimg(:,:,k) = ch;
end