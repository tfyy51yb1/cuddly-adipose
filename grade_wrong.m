%function G = grade_wrong();
%This function retrieves data from the result_data array 
%and calculates the difference between the grade the main program
%classified and the actual grade.
%The result of this function is used in the SUBPLOT module.
%
%OUTPUT
%G  array of calculated values as described above
%
%Josef Hammar, Marcus Grip, 2015
function A = grade_wrong()
global result_data
global images2
A = []; 
n = numel(result_data);
n = n/7;
for k=1:n
        a = result_data{k, 2};
        b = result_data{k, 7};
        Y = a-b
        A = [A, Y];
    end
end