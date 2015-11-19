% function result = match_sample(descriptor, training_data)
%
% This funtion matches a sample to those stored in a training data
% structure, and returns either a k-NN classification or a k-NN mean value.
%
% INPUT
% descriptor        image descriptor
% training_data     training data structure containing all necessary
%                   parameters
%                   
% OUTPUT
% result        result struct with fields:
%                   value: estimated value (grade or age)
%                   votes: neighbour votes (if classification mode)
%                   neighbour_values: values of neighbours
%                   matchidx: indices of neighbours
%                   distances: distances to neighbours
%
% Marcus Wallenberg, 2015

function result = match_sample(descriptor, training_data)
    
[idx, d] = match_descriptor_knn(descriptor, ...
                                training_data.descriptors, ...
                                training_data.pars.matching_pars.k,...
                                training_data.pars.matching_pars.disttype);                            

result = struct;                            
                            
switch(training_data.mode)
    case 'classify'
        grades = unique(training_data.vals);
        votes = hist(training_data.vals(idx), grades);
        [~, maxidx] = max(votes);
        estgrade = grades(maxidx);
        result.value = estgrade;
        result.votes = votes;
    case 'estimate'
        vals = training_data.vals(idx);
        result.value = mean(vals);        
end
     
result.matchidx = idx;
result.distances = d;
result.descriptor = descriptor;