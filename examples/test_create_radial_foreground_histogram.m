% This is an example of how to calculate an average radial foreground
% histogram for one of the plaque images

% make a list of the RAW files
data_path = '/home/wallenberg/Data/Amyloids/mouse_brain';
file_list = make_file_list(data_path, '*.raw');

% read the reference spectra, they're included in the toolbox dist
refspect_path = '/home/wallenberg/SVN/TFYY51/2015-HT/tools-dist/reference_spectra';
% load spectra for qFTAA and hFTAA (they will be loaded in the order given)
spectral_component_names = {'qFTAA', 'hFTAA'};
refspectra = load_reference_spectra(refspect_path, spectral_component_names);

% on my machine (may be platform-dependent) a good test image is number 44
% (age681_2.raw)
% This is a really good image, which should be easy to work with
imgdata = readASIraw(file_list{44});

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
pars.mode = 'proj'; %Use projection (faster than LS)
pars.use_affine = false; % use linear model, not affine (only matters if using LS)
pars.enforce_positive = true; % force coefficients to be positive (only matters if using LS)
% use fit_spectral_coefficients to create an image 
[component_img, residual]= fit_spectral_coefficients(imgdata, refspectra, signal_mask, pars);

% show the resulting spectral components, and a false-colour RGB
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
core_mask = signal_mask; % unnecessary, but done for clarity;
pars = struct;
pars.sigma = 10;
pars.nsize = 2*pars.sigma;
pars.min_region_size = 100;
pars.n_angle_bins = 16;
pars.n_radius_bins = 16;
fg_meanhist = calc_radial_foreground_histograms(component_img, core_mask, signal_mask, pars);

% first spectral component is now in fg_meanhist(:,:,1), and the second one
% is in fg_meanhist(:,:,2)
%%
%we can normalise away the intensity difference between the core and the
%periphery by normalising each histogram component
binsums = sum(fg_meanhist, 3);
% dividing the histogram by the sum gives us something which is independent
% of intensity, and only shows relative concentrations
fg_meanhist = fg_meanhist./repmat(binsums, [1 1 size(fg_meanhist, 3)]);

figure(36);clf;
hold on;
h1 = plot(fg_meanhist(:,:,1)', 'r-'); %plot first component
h2 = plot(fg_meanhist(:,:,2)', 'b-'); %plot second component
hold off;
legend([h1 h2], spectral_component_names);
title('Normalised radial distribution of spectral components');
xlabel('Distance from core center');
ylabel('Relative emission strength');
drawnow;

% fg_meanhist is what you want to insert into the database

    
 
