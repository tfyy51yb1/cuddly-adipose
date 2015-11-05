% This is an example of how to calculate an average foreground
% histogram for one of the adipose biopsy images

% make a list of the RAW files
data_path = '/home/wallenberg/Data/Amyloids/adipose_biopsy';
file_list = make_file_list(data_path, '*.raw');

% read the reference spectra, they're included in the toolbox dist
refspect_path = '/home/wallenberg/SVN/TFYY51/2015-HT/tools-dist/reference_spectra';
% load spectra for adpose tissue and hFTAA (they will be loaded in the order given)
spectral_component_names = {'adipose', 'hFTAA'};
refspectra = load_reference_spectra(refspect_path, spectral_component_names);

% on my machine (may be platform-dependent) a good test image is number 1
% (grade0_01.raw)
% This is a really good image, which should be easy to work with
imgdata = readASIraw(file_list{10});

% we have to cast imgdata to double for later operations, so we might as
% well do it now.
imgdata = double(imgdata);

% create an RGB image just for visualisation and show it.
rgbimg = multispect2rgb(imgdata);
figure(33);clf;imagesc(rgbimg);axis image;
title('False-colour RGB image');
drawnow;

% get a foreground mask using threshold_signal_image
pars = struct;
pars.flatten_mode = 'sum';
pars.method = 'automatic';
pars.normalisefl = true;
pars.n_erosion_steps = 2;
pars.n_dilation_steps = 10;
pars.threshold_value = 0;
pars.gammaval = 1;
pars.min_region_size = 1e-1;
signal_mask = threshold_signal_image(imgdata, pars);

% Display the mask and the product of the mask and RGB images
figure(34);
subplot(1, 2, 1);
imagesc(signal_mask);axis image;colormap gray;
title('Foreground mask');
subplot(1, 2, 2);
% we have to repeat the mask three times for the R, G and B channels
imagesc(rgbimg.*repmat(signal_mask, [1 1 3]));axis image;
title('Foreground mask applied to false-colour image');
drawnow;

% fit spectral components
pars = struct;
pars.mode = 'proj'; % Use projection mode, not LS)
pars.use_affine = false; % use linear model, not affine (only matters in LS)
pars.enforce_positive = false; % ignore negative values in solution (runs faster)
% use fit_spectral_coefficients to create an image 
[component_img, residual]= fit_spectral_coefficients(imgdata, refspectra, signal_mask, pars);

% show the resulting spectral components and the error
figure(35);clf;
subplot(1, 3, 1);
imagesc(component_img(:,:,1));axis image %This is the first component
title(spectral_component_names{1});
subplot(1, 3, 2);
imagesc(component_img(:,:,2));axis image % This is the second component
title(spectral_component_names{2});
subplot(1, 3, 3);
imagesc(residual);axis image;
title('Error in spectral fit');
drawnow;

% create an average histogram of the foreground regions, use the same core
% and foreground mask
fg_meanhist = calc_foreground_histogram(component_img, signal_mask);

% first spectral component is now in fg_meanhist(1, 1), and the second one
% is in fg_meanhist(2, 1)

figure(36);clf;
hold on;
h1 = bar(1, fg_meanhist(1, 1), 'r'); %plot first component
h2 = bar(2, fg_meanhist(2, 1)', 'b'); %plot second component
hold off;
legend([h1 h2], spectral_component_names);
title('Normalised distribution of spectral components');
xlabel('Component');
ylabel('Relative emission strength');
drawnow;

% fg_meanhist is what you want to insert into the database

    
 
