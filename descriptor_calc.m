%Skapa funktionen. Filename och refspectra tillhandahålls av annan funktion.
function descriptor = descriptor_calc(filename, refspectra)

%Omvandla filename, en fil av typen .raw, till en bildmatris, imgdata.
global image_type

switch(image_type)
    case 'real'
        [imgdata, ~] = readASIraw(filename);
    case 'synthetic'
        %Kod för att funktionen ska kunna använda syntetiska bilder?
        imgdata = load(filename);
        imgdata = imgdata.imgdata;
end

%Konvertera imgdata från uint16 till double och spara det i imgdata_double
imgdata_double = double(imgdata);

%Använd utvärdet 'mask' från funktionen threshold_signal_image.
[mask, ~, ~] = Use_threshold_signal_image(imgdata);

%Sätt parametrarna 'use_affine' till true och 'enforce_positive' till false.
pars = struct('use_affine', true, 'enforce_positive', false);

%Funktionen fit_spectral_coefficients returnerar spektralkoefficientbilden coeff_img.
[coeff_img, ~] = fit_spectral_coefficients(imgdata_double, refspectra, mask, pars);

%Beräkna ett histogram av bildens förgrund som är bildens 'descriptor'.
descriptor = calc_foreground_histogram(coeff_img, mask);
