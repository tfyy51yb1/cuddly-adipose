function images = get_Dataset();

%%[Filename, Path] = path_filename(); %% Have the user select a folder containing images to be processed
[filename, path] = uigetfile( ...
{  '*.mat;','All Files (*.*)'},...
   'Get file', ...
   'MultiSelect', 'on', 'C:\');


images = make_file_list(path, '*.mat'); %%make a list of paths to the images
end