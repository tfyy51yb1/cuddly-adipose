% function img = ndimresize(img, imsize, mode)
%
% This function resizes a matrix of MxNxD elements (such as a hyperspectral
% image) to the size specified by imsize (1x3 matrix with desired number of
% [rows, cols, channels]).
%
% INPUT
% img - MxNxD image matrix
% imsize - desired output size [rows, columns, channels]
% mode - optional interpolation mode string, see documentation for imresize
%
% OUTPUT
% img - resampled image matrix with desired size
% 
% Marcus Wallenberg, 2015
function img = ndimresize(img, imsize, mode)

if ~exist('mode', 'var')
    mode = 'bilinear';
end

[rows, cols, dims] = size(img);

%resize third dim first
img = permute(img, [3 1 2]);
img = imresize(img, [imsize(3), rows], mode);
img = permute(img, [2 3 1]);
img = imresize(img, [imsize(1), imsize(2)], mode);