% function training_data = insert_sample(training_data, descriptor, value)
%
% This function inserts a single new sample into an existing database
% structure. 
%
% INPUT
% training_data     initialised training data struct (see init_database.m)
% descriptor        image descriptor to insert
% value             parameter value asociated with this sample 
%                   (grade or age)
%
% OUTPUT
% training_data      updated training data structure
%
% Marcus Wallenberg, 2015
function training_data = insert_sample(training_data, descriptor, value)

training_data.vals = [training_data.vals value];
training_data.descriptors = cat(2, training_data.descriptors, descriptor);