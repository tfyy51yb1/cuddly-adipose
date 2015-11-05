% function [coeff_img, residual] = fit_spectral_coefficients(spect_img, refspectra, mask, pars)
% This function fits a distribution of known spectral components speficied
% by refspectra to an image containing oberserved spectra using a
% least-squares method or an orthogonal projection. The image is assumed to be a linear or affine
% function of the spectral components.
%
% INPUT
% spect_img         hyperspectral image with D bands (RxCxD)
% refspectra        cell array of arrays of reference spectra 
%                   (the function will find those matching the image settings automatically)
% mask              mask indicating at which pixel positions to estimate
% pars              parameter struct with fields:
%                       mode: 'ls' (least squares) or 
%                             'proj' (projection)
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

nbands_img = size(spect_img, 3);
nbands_spect = numel(refspectra{1}{1});
if nbands_img ~= nbands_spect
    spect_img = ndimresize(spect_img, [size(spect_img, 1), size(spect_img, 2), nbands_spect]);
end
nbands = nbands_spect;

%since we've forced the resampling, this is not really necessary any more
refspect_ls = [];
for k=1:numel(refspectra)
    for n = 1:numel(refspectra{k})
        if numel(refspectra{k}{n}) == nbands
            refspect_ls = cat(1, refspect_ls, refspectra{k}{n});
            break;
        end
    end
end
if isempty(refspectra)
    % and this should never happen
    error('Reference spectra do not match image!');
end

switch pars.mode
    case 'ls'
        
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
                
                if ~pars.enforce_positive %Then just clamp
                    x = max(0, x);
                end
                
                residual(j, k) = norm(refspect_ls*x - b);
                
                if(pars.enforce_positive) && (sum(x(1:numel(refspectra)) < 0) > 0)
                    n_enforced = n_enforced + 1;
                    %             disp(['Enforcing positivity constraint for x =  ' num2str(x'), ', ' num2str(n_enforced) ' points recalculated']);
                    [x, residual(j, k)] = lsqnonneg(refspect_ls, b, opts);
                end
                
                coeff_img(j, k, :) = reshape(x, 1, 1, []);
                
            end
            %     figure(1001);clf;
            %     imagesc(normalise_image(cat(3, coeff_img, zeros(size(coeff_img(:,:,1))))));axis image;
            %     drawnow;            
        end
        coeff_img = max(0, coeff_img);
    case 'proj'
        % normalise spectra
        for k=1:size(refspect_ls, 1)
            refspect_ls(k, 1, :) = refspect_ls(k, 1, :)/sqrt(sum(refspect_ls(k, 1, :).^3, 3));
        end
        est_spect_img = zeros(size(spect_img));
        for k=1:size(refspect_ls, 1)
            coeff_img(:,:,k) = sum(spect_img.*repmat(refspect_ls(k, 1, :), [size(spect_img, 1), size(spect_img, 2), 1]), 3);
            est_spect_img = est_spect_img + repmat(coeff_img(:,:,k), [1 1 nbands]).*...
                repmat(refspect_ls(k, 1, :), [size(spect_img, 1), size(spect_img, 2), 1]);
        end
        residual = sum(abs(spect_img - est_spect_img), 3);
        coeff_img = max(0, coeff_img);
    otherwise
        error('Unknown mode! (must be ls or op)');
end
