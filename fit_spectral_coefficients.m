% function [coeff_img, residual] = fit_spectral_coefficients(spect_img, refspectra, mask, pars)
% This function fits a distribution of known spectral components speficied
% by refspectra to an image containing oberserved spectra using a
% least-squares method. The image is assumed to be a linear or affine
% function of the spectral components.
%
% INPUT
% spect_img         hyperspectral image with D bands (RxCxD)
% refspectra        cell array of arrays of reference spectra 
%                   (the function will find those matching the image settings automatically)
% mask              mask indicating at which pixel positions to estimate
% pars              parameter struct with fields:
%                       use_affine: (true/false) if true, use affine
%                                   model, otherwise use linear model
%                       enforce_positive: (true/false) if true, enforce
%                                          positivity of spectral
%                                          coefficients using lsqnonneg
%                       
% OUTPUT
% coeff_img         coefficient image (RxCxN)
% residual          norm of spectral fit error at each location (RxCx1) 
%
% Marcus Wallenberg, 2015
function [coeff_img, residual] = fit_spectral_coefficients(spect_img, refspectra, mask, pars)

coeff_img = zeros(size(spect_img, 1), size(spect_img, 2), numel(refspectra));

nbands = size(spect_img, 3);

refspect_ls = [];
for k=1:numel(refspectra)
    for n = 1:numel(refspectra{k})
        if numel(refspectra{k}{n} == nbands)
            refspect_ls = cat(1, refspect_ls, refspectra{k}{n});
            break;
        end
    end
end

refspect_ls = permute(refspect_ls, [3 1 2]);
if pars.use_affine
    refspect_ls = [refspect_ls ones(size(refspect_ls, 1), 1)];
    coeff_img = cat(3, coeff_img, zeros(size(coeff_img(:,:,1))));
end

residual = zeros(size(coeff_img(:,:,1)));

if pars.enforce_positive
    opts = optimset('Display', 'off');
    n_enforced = 0;
end

maskfl = ~isempty(mask);

for j=1:size(coeff_img, 1)
    for k=1:size(coeff_img, 2)
        if maskfl && ~mask(j, k)
            continue;
        end
        
        b = permute(spect_img(j, k, :), [3 1 2]);
        x = refspect_ls\b;                
                     
        
        residual(j, k) = norm(refspect_ls*x - b);         
        
        if(pars.enforce_positive) && (sum(x(1:size(refspectra, 1)) < 0) > 0)
            n_enforced = n_enforced + 1;
%             disp(['Enforcing positivity constraint for x =  ' num2str(x'), ', ' num2str(n_enforced) ' points recalculated']);
            [x, residual(j, k)] = lsqnonneg(refspect_ls, b, opts);
        end
        
        coeff_img(j, k, :) = reshape(x, 1, 1, []);        
              
    end
end