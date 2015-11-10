% function [spect_img, coefficient_img] = make_synth_adipose_image(reference_spectra, coefficient_img, density, grade, imsize)
%
% This function makes a synthetic adipose biopsy image that can be used for
% testing of the toolbox functions. However, it is far from the real thing
% in terms of variability of structures. Also, note that these image are in
% double precision, whereas the real images are uint16 and will need to be
% converted after reading.
%
% INPUT
% reference_spectra     reference spectra, as provided by
%                       load_reference_spectra.m
%                       The order should be {'adipose', 'hFTAA'}.
% coefficient_img       optional user-defined spectral coefficient image
%                       set to [] to generate one automatically
% density               a parameter that controls the number of
%                       emission maxima. Typical value is 1e-2 to 1e-1
% grade                 The desired grade (0 to 4). NB that these do not
%                       correspond to the real grades and are only for
%                       testing purposes
% imsize                [1x2] matrix of image YX size [rows, columns]
%
% OUTPUT
% spect_img             synthetic hyperspectral image
% coefficient_img       image of true spectral coefficients
%
% Marcus Wallenberg, 2015
function [spect_img, coefficient_img] = make_synth_adipose_image(reference_spectra, coefficient_img, density, grade, imsize)
ncomponents = numel(reference_spectra);
nbands = size(reference_spectra{1}{1}, 3);
if isempty(coefficient_img)
    npixels = prod(imsize);
    nfilter_iterations = 5;    
    
    coefficient_img = zeros(imsize(1), imsize(2), ncomponents);
    
    nclusters = ceil(density*npixels);
    
    ksize = ceil(imsize/20);
    
    kern = fspecial('gaussian', ksize, mean(ksize)/10);
    
    for k=1:ncomponents
        ch = zeros(imsize);
        
        m = [rand(2,nclusters)];
        m(1, :) = max(1, min(imsize(1), round(m(1, :)*imsize(1))));
        m(2, :) = max(1, min(imsize(2), round(m(2, :)*imsize(2))));
        
        for n=1:nclusters
            ch(m(1, n), m(2, n)) = 1;
        end
        
        for n=1:nfilter_iterations
            ch = conv2(ch, kern, 'same');
            ch = medfilt2(ch, ceil(ksize/2));
            [dx, dy] = gradient(ch);
            gmag = sqrt(dx.^2 + dy.^2);
            ch = ch + gmag;
            ch = ch/max(max(ch));
        end
        
        coefficient_img(:,:,k) = ch;
    end
    
    mask = sum(coefficient_img, 3)/ncomponents;
    mask = exp(-(1 - mask).^2/(2*0.25^2));
    
    coefficient_img = coefficient_img.*repmat(mask, [1 1 ncomponents]);
    coefficient_img(:,:,2) = coefficient_img(:,:,2)*grade/2;
    coefficient_img = max(0, coefficient_img);
end

spect_img = zeros(imsize(1), imsize(2), nbands);
for k=1:ncomponents
    spect_img = spect_img + ...
        repmat(reference_spectra{k}{1}, [imsize(1), imsize(2), 1]).*...
        repmat(coefficient_img(:,:,k), [1 1 nbands]);
end