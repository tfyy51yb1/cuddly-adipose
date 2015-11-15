%%---------------------------------------
%%Adipose Main
%%---------------------------------------

function main()


%%---------------------------------------
%%Run-once supporting functions
%%---------------------------------------


%%get a list of real images

%images = get_Images(); 

%%---------------------------------------
%%use synthetic dataset
%%---------------------------------------

%%images used to generate database
images = get_Dataset;

%%images to match with databse
%images2 = get_Dataset;

%%get reference spectra
refspectra = get_refspectra();

%%---------------------------------------
%%initialize database.
%%---------------------------------------

global training_data;
training_data = init_database(refspectra, struct(), 'classify');


%%---------------------------------------
%%pipeline loop
%%---------------------------------------

%%function build_database returns updated database structure.
training_data = build_database(images, refspectra);

%%function match_db matches samples with database. currently out of
%%order...
%result = match_db(images2, refspectra, training_data);
