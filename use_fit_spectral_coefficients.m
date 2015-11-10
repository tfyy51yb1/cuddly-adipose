function [coeff_img, residual] = use_fit_spectral_coefficients %Gör detta till en funktion.

spect_img = Image_gen(3); %Använd funktionen spect_img för att generera en bild av grad 3 för testningssyften. Måste anpassas för verklig testdata i ett senare skede.

pars = struct('use_affine', false, 'enforce_positive', false); %Jag är inte helt hundra på vilka värden som är att föredra, har valt att inte använda något av dem. Vidare forskning krävs.

refspectra = load_reference_spectra('C:\Users\Oscar\Desktop\tools-dist\reference_spectra', {'adipose', 'hFTAA'}); %Ladda referensspektra. Bör kunna effektivisseras så att detta inte görs separat i flera funktioner.
%Notera att sökvägen är hårdkodad. Ändras vid senare tillfälle.

[mask, ~, ~] = Use_threshold_signal_image; %Använd funktionen Use_threshold_signal_images utvärde 'mask' för att maska spect_img. 

[coeff_img, residual] = fit_spectral_coefficients(spect_img, refspectra, mask, pars); %Funktionen fit_spectral_coefficients gör sin magi.
