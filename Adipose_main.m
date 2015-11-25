
%%Adipose Main

%initilaize global variables
global training_data;
global result_data;

%%select images used to generate database
images = get_Images;

%%select images to match with databse
images2 = get_Images;

%%get reference spectra
refspectra = get_refspectra();

%%---------------------------------------
%%initialize database.
%%---------------------------------------

%setup parameters for database generation
% 'k' is the number of neigbours to sample. All disttypes except SAD are
% untested
s = struct('matching_pars', struct('k', 3, 'disttype', 'SAD'));

%initialize database
training_data = init_database(refspectra, s, 'classify');


%%function build_database calculates reference histograms and returns updated database structure.
training_data = build_database(images, refspectra)

%%function match_db matches samples with database. results can be seen in
%%global variable result_data
match_db(images2, refspectra, training_data);
