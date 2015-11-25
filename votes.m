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
