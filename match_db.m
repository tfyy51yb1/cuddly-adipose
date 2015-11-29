%function match_db(images, refspectra, training_data, fit_spectral_pars)
%Wrapper function responsible for caling functions involved in matching
%samples to the database.
%
%INPUT
%images                 Image files to match with database
%refspectra             Reference spectra
%training_data          Database structure used for comparing samples of
%                       unknown grade to known grade training samples.
%fit_spectral_pars      Parameter struct with fields use_affine and
%                       enforce_positive. Passed through to the function 
%                       descriptor_calc and then to fit_spectral_coefficients.
%
%OUTPUT
%None
%

function match_db(images, refspectra, training_data, fit_spectral_pars)

%Loop through input images. Calculate descriptor for each image. Compare
%descriptor with database. Add result to cell array.
for k=1:numel(images)
    histogram = descriptor_calc(images{k}, refspectra, fit_spectral_pars);
    result = match_sample(histogram, training_data);
    addvalues_result(images{k}, result);
end