function [A, B] = votes()
global images2
global result_data
A = [];
B = [];
    for k=1:numel(images2)
    
    
        A = [A; result_data{k, 3}];
        %C = [result_data{k, 7}];
        B = [B; result_data{k, 7}];
    end

end
