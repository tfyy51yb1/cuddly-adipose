global result_data
correct = 0;
smaller = 0;
higher = 0;
for k=1:numel(images2)
    a = result_data{k, 2}
    b = result_data{k, 7}
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
a = a * 100;
disp(a)
        