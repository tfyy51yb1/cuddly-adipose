function descriptor = descriptor_calc(filename, refspectra)%Skapa funktionen. Filename och refspectra tillhandahålls av annan funktion.
[imgdata, ~] = readASIraw(filename);%Omvandla filename, en fil av typen .raw, till en bildmatris, imgdata.
imgdata_double = double(imgdata);%Konvertera imgdata från uint16 till double och spara det i imgdata_double.
[mask, ~, ~] = Use_threshold_signal_image(imgdata);%Använd utvärdet 'mask' från funktionen threshold_signal_image.
pars = struct('use_affine', false, 'enforce_positive', false);%Sätt parametrarna 'use_affine' och 'enforce_positive' till false.
[coeff_img, ~] = fit_spectral_coefficients(imgdata_double, refspectra, mask, pars);%Funktionen fit_spectral_coefficients returnerar spektralkoefficientbilden coeff_img.
descriptor = calc_foreground_histogram(coeff_img, mask);%Beräkna ett histogram av bildens förgrund som är bildens 'descriptor'.
