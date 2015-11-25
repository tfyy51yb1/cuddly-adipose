%Skapa funktionen. Filename och refspectra tillhandahålls av annan funktion.
function descriptor = descriptor_calc(filename, refspectra, spectral_pars, threshold_pars_init)

%Omvandla filename, en fil av typen .raw, till en bildmatris, imgdata.
[imgdata, ~] = readASIraw(filename);

%Kod för att funktionen ska kunna använda syntetiska bilder?
%imgdata = load(filename);
%imgdata = imgdata.imgdata;

%Konvertera imgdata från uint16 till double och spara det i imgdata_double
imgdata_double = double(imgdata);

%Använd utvärdet 'mask' från funktionen threshold_signal_image.
global threshold_pars
[mask, threshold_value, ReturnImage] = threshold_signal_image(imgdata, threshold_pars);

%Funktionen fit_spectral_coefficients returnerar spektralkoefficientbilden coeff_img.
[coeff_img, ~] = fit_spectral_coefficients(imgdata_double, refspectra, mask, spectral_pars);

%Beräkna ett histogram av bildens förgrund som är bildens 'descriptor'.
descriptor = calc_foreground_histogram(coeff_img, mask);