% function whist = calc_weighted_histogram(histograms, labelim)
%
% This function calculates a label-weighted histogram, using the number of
% pixels with a specific label as a weight. It is used internally by
% calc_radial_foreground_histograms.m
%
% INPUT
% histograms MxNxD histogram data (M bins, N regions, D channels)
% labelim          label image with labels 1:N corresponding to the histograms 
%
% OUTPUT
% whist             weighted and re-normalised histogram
%
% Marcus Wallenberg, 2015
function whist = calc_weighted_histogram(histograms, labelim)

whist = zeros(size(histograms, 1), 1, size(histograms, 3));

for k=1:max(max(labelim))
    whist = whist + sum(sum(labelim == k))*histograms(:, k, :);
end

whist = whist/sum(whist(:));