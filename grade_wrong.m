function A = grade_wrong()
global result_data
global images2
A = [];    
for k=1:numel(images2)
        a = result_data{k, 2};
        b = result_data{k, 7};
        Y = a-b
        A = [A, Y];
    end
end