% function [A, B] = votes()
% This function pulls result data from the result_data array, and formats
% it for use in the SUBPLOT function
% 
% OUTPUT
% A         votes from result_data
% B         corresponding true grades 
%
% Jens Grundmark, 2015

function [A, B] = votes()
global images2
global result_data
A = [];
B = [];
a = numel(result_data);
a = a/7;
        for k=1:a    
        A = [A; result_data{k, 3}];
        
        B = [B; result_data{k, 7}];
    end

end
