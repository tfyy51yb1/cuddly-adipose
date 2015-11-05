% function [mask, threshold_value, flattened_img] = threshold_signal_image(img, pars)
% 
% This function thresholds a single-channel image using either manual or
% automatic thresholding. It also applies erosion and dilation operation,
% as specified by the provided parameters. The mask returned is the result
% of morphological operations on the regions of the image larger than the
% threshold value.
%
% INPUT
% img           input single-channel image
% pars          parameter struct with fields:
%                   flatten_mode: how to flatten image before thresholding
%                                 ('max', or 'sum'). Has no effect on
%                                 single-channel images
%                   threshold_value: threshold value (manual mode)
%                                    starting value (automatic mode)
%                   method: 'manual',    simple thresholding (img > threshold_value)
%                           'automatic', mid-point automatic thresholding (img > threshold_value)
%                   n_erosion_steps: number of erosion steps following threshold
%                   n_dilation_steps: number of dilation steps following erosion
%                   normalisefl: true/false, if true, the image is normalised to zero
%                                mean and unit variance
%                   gammaval: gamma value to apply as (image).^gammaval
% OUTPUT
% mask              logical mask
% threshold_value   threshold value used (same as input for manual mode)
% flattened_img     flattened image with applied normalisation and gamma
%
% Marcus Wallenberg, 2015
function [mask, threshold_value, flattened_img] = threshold_signal_image(img, pars)

% if the image is not double-precision, convert it here
info = whos('img');
if ~strcmp(info.class, 'double')
    img = double(img);
end

switch pars.flatten_mode
    case 'sum'
        img = sum(img, 3);
    case 'max'
        img = max(img, [], 3);
    otherwise
        error('Unknown flattening mode. Must be max or sum');
end

img = img.^pars.gammaval;

if pars.normalisefl    
    img = img - mean(mean(img));
    img = img/std(img(:));
end



switch pars.method
    case 'manual'
        mask = img > pars.threshold_value;
        threshold_value = pars.threshold_value;
    case 'automatic'
        % mid-point bimodal method
        next_mask = img > pars.threshold_value;
        mask = ~next_mask;        
        while sum(sum(abs(mask - next_mask))) > 0
            mask = next_mask;
            m0 = mean(img(~mask));
            v0 = var(img(~mask));
            m1 = mean(img(mask));
            v1 = var(img(mask));
            
            %simple mid-point method
            threshold_value = mean([m0 m1]);
            next_mask = img > threshold_value;                     
        end
        mask = next_mask;
    otherwise
        error(['Unknown thresholding method: ',...
               pars.method,...
               ', choices are manual/automatic']);
end

mask = bwmorph(mask, 'erode', pars.n_erosion_steps);
mask = bwmorph(mask, 'dilate', pars.n_dilation_steps);
        
labelim = bwlabel(mask);
for k=1:max(max(labelim))
    lmask = labelim == k;
    if(sum(sum(lmask)) < pars.min_region_size)
        mask(lmask) = false;
    end
end

flattened_img = img;
        
