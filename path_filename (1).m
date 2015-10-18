%Let's the user choose a specific file. If the file doesn't exist
%or the user closes the window;both path and filename will return the value 0.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%readASIraw.m uses the 'filename' below as input whilst make_file_list uses 
%the variable path as an input.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Input    -> The users command
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Output   -> Pathname ('path') (eg. 'C:\Users...) and a filename.'(eg .raw,
%.png, .txt)'.
[filename, path] = uigetfile( ...
{  '*.jpg;*.tif;*.png;*.gif;*.bmp;*.raw','All Image Files';'*.*','All Files (*.*)'},...
   'Get file', ...
   'MultiSelect', 'on', 'C:\');
