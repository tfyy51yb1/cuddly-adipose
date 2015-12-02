%function X = percentages();
%This function retrieves data from the result_data array 
%and calculates the distribution of how many classifications that were
%correct. The ones that were not correct are calculated in two different
%classes; the ones that are classified higher than their actual grade, and
%the ones that are classified lower.
%
%The result from this function is used in the SUBPLOT module.
%
%OUTPUT
%X      array containing the distribution as described above.
%
%Jens Grundmark, Josef Hammar, Marcus Grip, 2015
function X = percentages()
global result_data
global images2
correct = 0;
smaller = 0;
higher = 0;
n = numel(result_data);
n = n/7;
for k=1:n
    a = result_data{k, 2};
    b = result_data{k, 7};
    if a < b
        smaller = smaller + 1;
        else if a > b
                higher = higher +1;
            else
                correct = correct + 1;

            end
    end
end
b = smaller+higher+correct;
a = correct/b;
c = higher/b;
d = smaller/b;
a = a * 100;
c = c * 100;
d = d * 100;
disp(a)
X = [a c d];

end