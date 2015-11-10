%%test function for evaluation of other functions, such as threshold_signal_image
%%generate a single image of a certain grade to test

function [imgdata] = Image_gen(grade)

    nrows = 300; %make images have 300 rows (Y)
    ncols = 400; %make images have 400 columns (X)
    imsize = [nrows, ncols]; % build size vector;
    density = 5e-2; %medium-dense images (see documentation for good values)
    %%grade = 4; % image grade
    types = {'adipose', 'hFTAA'}; % These are the spectra to use for this type of image

    

    datapath = 'C:\Users\Jens\Documents\GitHub\cuddly-adipose\reference_spectra\'; %%hard coded path. should be changed

    reference_spectra = load_reference_spectra(datapath, types);

  


    imgdata = make_synth_adipose_image(reference_spectra, [], density, grade, imsize);
%     rgbimg = multispect2rgb(imgdata)
%     
%     % collapse image by summing over all bands
%     sumimg = sum(imgdata, 3);       
%     % get average spectrum of all pixels by averaging over Y and X
%     avg_spectrum = mean(mean(imgdata, 1), 2);
%     % turn into a row vector so we can plot it
%     avg_spectrum = permute(avg_spectrum, [1 3 2]);
%     % dividing by exposure (metadata.exp) time should normalise correctly, but it doesn't
%     % normalise so that energy is 1
%     avg_spectrum = avg_spectrum/sqrt(sum(avg_spectrum.^2));
%     imshow(sumimg)
%     
end