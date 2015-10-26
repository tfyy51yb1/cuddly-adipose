function images = get_Images();

[Filename, Path] = path_filename(); %% Have the user select a folder containing images to be processed
images = make_file_list(Path, '*.raw'); %%make a list of paths to the images
end