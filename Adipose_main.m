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
images2 = get_Dataset;

%%get reference spectra
refspectra = get_refspectra();

%%---------------------------------------
%%initialize database.
%%---------------------------------------

global training_data;

%%Det här löste felet med matching.pars och så vidare. Om man vill kan man
%%ju testa att ändra värdet på 'k', som jag inte vet vad det är, och på
%%'disttype' vars giltiga värden finns i match_descriptor_knn.
%%Det verkar som att 0 < k ? images (antalet bilder i databasen).
%%Man kan även byta mellan lägena 'classify' och 'estimate'.
s = struct('matching_pars', struct('k', 10, 'disttype', 'SAD'));

training_data = init_database(refspectra, s, 'classify');


%%---------------------------------------
%%pipeline loop
%%---------------------------------------

%%function build_database returns updated database structure.
training_data = build_database(images, refspectra)

%%function match_db matches samples with database. currently out of
%%order...
result = match_db(images2, refspectra, training_data);
