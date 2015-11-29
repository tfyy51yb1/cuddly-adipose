%function training_data = build_database(images, refspectra, fit_spectral_pars)
%Wrapper function responsible for caling functions involved in database
%building.
%
%INPUT
%images                 Image files to insert into database
%refspectra             Reference spectra
%fit_spectral_pars      Parameter struct with fields use_affine and
%                       enforce_positive. Passed through to the function 
%                       descriptor_calc and then to fit_spectral_coefficients.
%
%OUTPUT
%training_data          Updated databse structure
%

function training_data = build_database(images, refspectra, fit_spectral_pars)

global training_data;

%Loop through input images. Calculate descriptor and get the grade of each
%image from the filename. Insert information into database.
for k=1:numel(images)
    histogram = descriptor_calc(images{k}, refspectra, fit_spectral_pars);
    [~, grade, ~] = fileparts(images{k});
    grade = str2num(grade(6:6));
    training_data = insert_sample(training_data, histogram, grade);
disp('Database built!');
end