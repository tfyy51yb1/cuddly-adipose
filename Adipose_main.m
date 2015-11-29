
%%Adipose Main
clear;
clc;
%initilaize global variables
global training_data;
global result_data;
global images2


% use synthetic or real images?
global image_type
image_type = 'synthetic' %'real' or 'synthetic'


switch(image_type)
    case 'real'
        %%select images used to generate database
        images = get_Images;

        %%select images to match with database
        images2 = get_Images;
    case 'synthetic'
        %%select images used to generate database
        images = get_Dataset;
        
        %%select images to match with database
        images2 = get_Dataset;
end
%%get reference spectra
refspectra = get_refspectra();

%%---------------------------------------
%%initialize database.
%%---------------------------------------

%setup parameters for database generation
% 'k' is the number of neigbours to sample. All disttypes except SAD are
% untested
s = struct('matching_pars', struct('k', 3, 'disttype', 'SAD'));

%Create parameter structs to be utilized in fit_spectral_coefficients and threshold_signal_image.
fit_spectral_pars = struct('use_affine', false, 'enforce_positive', false);

global threshold_pars
threshold_pars = struct;
threshold_pars.flatten_mode = 'max'; 
threshold_pars.normalisefl = false; 
threshold_pars.method = 'manual'; 
threshold_pars.gammaval = 0.7; 
threshold_pars.threshold_value = 130; 
threshold_pars.n_erosion_steps = 0;
threshold_pars.n_dilation_steps = 0;
threshold_pars.min_region_size = 788;

%initialize database
training_data = init_database(refspectra, s, 'classify');


%%function build_database calculates reference histograms and returns updated database structure.
training_data = build_database(images, refspectra, fit_spectral_pars);

%%function match_db matches samples with database. results can be seen in
%%global variable result_data
match_db(images2, refspectra, training_data, fit_spectral_pars);
