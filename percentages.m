function X = percentages()
global result_data
global images2
correct = 0;
smaller = 0;
higher = 0;

for k=1:numel(images2)
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