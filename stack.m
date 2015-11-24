% used to create 
% y = [G0; G1; G2; G3; G4];
% bar(y)
global result_data
global images2
G0 = [];
G1 = [];
G2 = [];
G3 = [];
G4 = [];
for k=1:numel(images2)
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