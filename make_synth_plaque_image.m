% function [spect_img, coefficient_img] = make_synth_plaque_image(reference_spectra, coefficient_img, density, ageval, imsize)
%
% This function makes a synthetic brain biopsy image that can be used for
% testing of the toolbox functions. However, it is far from the real thing
% in terms of variability of structures. Also, note that these image are in
% double precision, whereas the real images are uint16 and will need to be
% converted after reading.
%
% INPUT
% reference_spectra     reference spectra, as provided by
%                       load_reference_spectra.m
%                       The order should be {'hFTAA', 'qFTAA'}.
% coefficient_img       optional user-defined spectral coefficient image
%                       set to [] to generate one automatically
% density               a parameter that controls the number of
%                       emission maxima. Typical value is 1e-4 to 3e-4
% ageval                The desired age value (5 to 23). NB that these do not
%                       correspond to the real age values and are only for
%                       testing purposes
% imsize                [1x2] matrix of image YX size [rows, columns]
%
% OUTPUT
% spect_img             synthetic hyperspectral image
% coefficient_img       image of true spectral coefficients
%
% Marcus Wallenberg, 2015
function [spect_img, coefficient_img] = make_synth_plaque_image(reference_spectra, coefficient_img, density, ageval, imsize)
nbands = size(reference_spectra{1}{1}, 3);
if isempty(coefficient_img)
    npixels = prod(imsize);
    ncomponents = numel(reference_spectra);
    if ncomponents ~= 2
        error('Number of spectral components must be two for this type of image');
    end
    
    nfilter_iterations = 1;
    
    
    coefficient_img = zeros(imsize(1), imsize(2), ncomponents);
    
    nclusters = ceil(density*npixels);
    
    ksize = ceil(imsize/10);
    
    m = [rand(2,nclusters)];
    m(1, :) = max(ksize(1), min(imsize(1)-ksize(1), round(m(1, :)*(imsize(1)-ksize(1)))));
    m(2, :) = max(ksize(2), min(imsize(2)-ksize(2), round(m(2, :)*(imsize(2)-ksize(2)))));
    
    for k=1:ncomponents
        ch = zeros(imsize);
        
        if k > 1
            scfac = max(1, ageval/11);
            kern = fspecial('gaussian', round(ksize*scfac), mean(ksize)/(8)*scfac);
        else
            scfac = max(1, ageval/5);
            kern = fspecial('gaussian', round(ksize*scfac), mean(ksize)/(8)*scfac);
        end
        
        
        for n=1:nclusters
            ch(m(1, n), m(2, n)) = rand*0.25 + 0.75;
        end
        ch = conv2(ch, kern, 'same');
        
        for n=1:nfilter_iterations
            ch_new = conv2(ch, kern, 'same');
%             if k > 1
            ch = ch_new;
%             else
%               ch = max(0, ch_new - ch);
%             end
%             ch = medfilt2(ch, ceil(ksize/2));
%             [dx, dy] = gradient(ch);
%             gmag = sqrt(dx.^2 + dy.^2);
%             ch = ch + gmag;
            ch = ch/max(max(ch));
        end
        coefficient_img(:,:,k) = ch;
    end
end

spect_img = zeros(imsize(1), imsize(2), nbands);
for k=1:ncomponents
    spect_img = spect_img + ...
        repmat(reference_spectra{k}{1}, [imsize(1), imsize(2), 1]).*...
        repmat(coefficient_img(:,:,k), [1 1 nbands]);
end