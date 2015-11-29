%function descriptor = descriptor_calc(filename, refspectra, fit_spectral_pars)
%
%Wrapper function responsible for calling the functions which are used when
%an image descriptor is calculated.
%
%INPUT
%filename               image file
%refspectra             Reference spectra
%fit_spectral_pars      Parameter struct with fields use_affine and
%                       enforce_positive. Passed through to the function
%                       fit_spectral_coefficients.
%
%OUTPUT
%descriptor             image descriptor
%

function descriptor = descriptor_calc(filename, refspectra, fit_spectral_pars)

%Read the raw image file. Return uint8 image data. Contains switch for
%changing between real and synthetic images.
global image_type

switch(image_type)
    case 'real'
        [imgdata, ~] = readASIraw(filename);
    case 'synthetic'
        imgdata = load(filename);
        imgdata = imgdata.imgdata;
end

%Cast imgdata from uint16 to double and save the double type variable in
%imgdata_double.
imgdata_double = double(imgdata);

%Run threshold_signal_image and save the resulting logical mask in variable
%mask.threshold_pars is a global parameter struct created by the GUI.
global threshold_pars
[mask, ~, ~] = threshold_signal_image(imgdata, threshold_pars);

%Run fit_spectral_coefficients and save the resulting coefficient image.
[coeff_img, ~] = fit_spectral_coefficients(imgdata_double, refspectra, mask, fit_spectral_pars);

%Calculate the image descriptor and return it.
descriptor = calc_foreground_histogram(coeff_img, mask);
