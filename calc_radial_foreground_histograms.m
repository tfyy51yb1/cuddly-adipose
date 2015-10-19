% function [histogram, labelim, maxima, region_histograms] = calc_radial_foreground_histograms(img, core_mask, histogram_mask, pars)
% 
% This function calculates normalised radial histograms of the components
% of the single- or multichannel image img in the regions specified by histogram_mask, starting from core centers
% found in core_mask and using the parameters specified by pars.
%
% INPUT
% img               input single- och multichannel image
% core_mask         mask used to locate centers of foreground regions
% histogram_mask    mask used to calculate radial histograms starting from
%                   these centers
% pars              parameter struct with fields:
%                       sigma: regularisation of distance function,
%                              Gaussian kernel with variance sigma^2.
%                              (in pixels)
%                       nsize: neighbourhood size for maximum search
%                              (in pixels)
%                       n_radius_bins: number of radial histogram bins
%                       n_angle_bins: number of angular histogram bins
%                                     (used for radial normalisation)
%
% OUTPUT
% histogram         weighted histogram of foreground, Mx1xD 
%                   (M regions, D channels)
% labelim           label image of foreground regions, as associated with
%                   region centers found in core_mask.
% maxima            region centers (contour distance maxima), [rows;cols]
% region_histograms output normalised radial histograms for all each region and channel,
%                   MxNxD matrix (M radial bins, N foreground regions, D channels)
%
% Marcus Wallenberg, 2015
function [histogram, labelim, maxima] = calc_radial_foreground_histograms(img, core_mask, histogram_mask, pars)

% find euclidean distance maxima in inverse foreground mask
distmap = bwdist(~core_mask);

%low-pass filter
kern = fspecial('gaussian', ceil(3*pars.sigma*ones(1, 2)), pars.sigma);
distmap = conv2(distmap, kern, 'same');

%find all local maxima with a set search size
maxima = find_local_maxima(distmap, core_mask, pars.nsize);

%label points by closest maximum
labelim = zeros(size(histogram_mask));
rmap = Inf*ones(size(histogram_mask));
phimap = zeros(size(histogram_mask));
[rows, cols, ndims] = size(histogram_mask);
[X, Y] = meshgrid(1:cols, 1:rows);

for k=1:size(maxima, 2)
    Xt = X - maxima(2, k);
    Yt = Y - maxima(1, k);
    r = sqrt(Xt.^2 + Yt.^2);
    labelim(r < rmap) = k;
    lmask = labelim == k;
    rmap(lmask) = r(lmask);
    phimap(lmask) = atan2(Yt(lmask), Xt(lmask));
end
labelim = labelim.*histogram_mask;
rmap = rmap.*histogram_mask;
phimap = phimap.*histogram_mask;
phimap(phimap < 0) = phimap(phimap < 0) + 2*pi;

quant_phi_map = phimap;
quant_phi_map(histogram_mask) = round((pars.n_angle_bins-1)*(phimap(histogram_mask)/(2*pi)) + 1);
norm_r_map = rmap;
for k=1:size(maxima, 2)
    for n=1:pars.n_angle_bins
        lmask = logical((labelim == k).*(quant_phi_map == n));
        norm_r_map(lmask) = rmap(lmask)/max(rmap(lmask));
    end
end

quant_norm_r_map = rmap;
quant_norm_r_map(histogram_mask) = round((pars.n_radius_bins-1)*norm_r_map(histogram_mask) + 1);

histogram = zeros(pars.n_radius_bins, size(maxima, 2), size(img, 3));

for k=1:size(maxima, 2)
    for n=1:pars.n_radius_bins        
        lmask = logical((labelim == k).*(quant_norm_r_map == n));
        for dim = 1:size(img, 3)         
            ch = img(:,:,dim);
            histogram(n, k, dim) = mean(ch(lmask));
        end
    end
end

histogram(isnan(histogram)) = 0;

region_histograms = histogram;
histogram = calc_weighted_histogram(histogram, labelim);
