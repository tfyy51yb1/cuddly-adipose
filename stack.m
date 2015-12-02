% function I = stack() 
% This function collects data from the result_data, and loops through two
% columns to check what the grades that were classified as for example
% zeroes, actually were. Note that this function only works if the amount
% of pictures are equal.
%The result of this function is used in the SUBPLOT module.
%Josef Hammar, Marcus Grip 2015
function I = stack()
global result_data
global images2
G0 = [];
G1 = [];
G2 = [];
G3 = [];
G4 = [];
n = numel(result_data);
n = n/7;
for k=1:n
     a = result_data{k, 2};
     b = result_data{k, 7};
     switch b
        case 0
            G0 = [G0, a];
        case 1
            G1 = [G1, a];
        case 2
            G2 = [G2, a];
        case 3
            G3 = [G3, a];
        case 4
            G4 = [G4, a];
        otherwise
             disp('ERROR!')
        end
           
    end
I = [G0; G1; G2; G3; G4];
end