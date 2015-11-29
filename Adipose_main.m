
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

%Create parameter struct to be utilized in fit_spectral_coefficients.
fit_spectral_pars = struct('use_affine', false, 'enforce_positive', false);

%initialize database
training_data = init_database(refspectra, s, 'classify');


%%function build_database calculates reference histograms and returns updated database structure.
training_data = build_database(images, refspectra, fit_spectral_pars);

%%function match_db matches samples with database. results can be seen in
%%global variable result_data
match_db(images2, refspectra, training_data, fit_spectral_pars);
