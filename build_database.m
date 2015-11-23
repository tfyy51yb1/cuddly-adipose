%%the function build_database steps through a list of input images, computes descriptors
%%and gets the grade of the images from their filenames.
%%it adds this information to the database struct which is then returned by
%%the function.

function training_data = build_database(images, refspectra)

global training_data;

for k=1:numel(images)
    histogram = descriptor_calc(images{k}, refspectra);
    [~, grade, ~] = fileparts(images{k});
    grade = str2num(grade(6:6));
    training_data = insert_sample(training_data, histogram, grade);
disp('Database built!');
end