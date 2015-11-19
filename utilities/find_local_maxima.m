% function pts = find_local_maxima(img, mask, nsize)
%
% This function finds local maxima in an image, using a search area size
% and a foreground mask. It is used internally in
% calc_radial_foreground_histograms.m
%
% INPUT
% img       single-channel image in which to find maxima
% mask      logical mask of locations to search
% nsize     size of neighbourhood to search in 
%           (smallest distance between maxima)
%
% OUTPUT
% pts       locations [rows;cols] of maxima
%
% Marcus Wallenberg, 2015
function pts = find_local_maxima(img, mask, nsize)

[rows, cols, ndims] = size(img);

if ndims ~= 1
    error('Input image must be 2D!');
end

offset = max(1, floor(nsize/2));

pts = [];

for j=1:rows
    for k=1:cols
        if(mask(j, k))
            ridx = max(1, j-offset):min(rows, j+offset);
            cidx = max(1, k-offset):min(cols, k+offset);
            p = img(ridx, cidx);
            p0 = img(j, k);
            
            pmask_strict = p > p0;
            
            if sum(pmask_strict) == 0;
                pts = [pts, [j;k]];
%                 disp(['Added point: ' num2str(pts(:, end)')]);                
            end
        end
    end
end


npts = size(pts, 2);
new_npts = 0;
while new_npts ~= npts
    npts = new_npts;
    d = zeros(size(pts, 2));
    for j=1:size(pts, 2)
        for k=j+1:size(pts, 2)
            d(j, k) = sqrt(sum((pts(:, j) - pts(:, k)).^2, 1));
            d(k, j) = d(j, k);
        end
    end
    for j=1:size(d, 1)
        [~, idx] = find(d(j, :) <= offset);
        if numel(idx) > 1
            break;
        end
    end
    if numel(idx) > 1
        pts(:, idx(1)) = mean(pts(:, idx), 2);
%         disp(['Merged points: ' num2str(idx)]);
        pts(:, idx(2:end)) = [];
    end
    new_npts = size(pts, 2);
end

