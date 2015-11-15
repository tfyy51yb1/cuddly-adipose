%%the function build_database steps through a list of input images, computes descriptors
%%and gets the grade of the images from their filenames.
%%it adds this information to the database struct which is then returned by
%%the function.

function training_data = build_database(images, refspectra)

global training_data;

for k=1:numel(images)
    histogram = descriptor_calc(images{k}, refspectra);
    [~, name, ~] = fileparts(images{k});
    name = strcat({name(end:end)});
    training_data = insert_sample(training_data, histogram, name)
end