


    %%test function
    %%however, Threshold_signal_image does not accept threshold values representet with more than one character. eg, 10 or 0,1

function [mask, threshold_value, ReturnImage] = Use_threshold_signal_image

%%set up parmameter struct
pars = struct;
pars.flatten_mode = 'sum'; %% 'sum' or 'max'
pars.normalisefl = false; %%true/false
pars.method = 'automatic' %% manual/automatic
pars.gammaval = 1 %%gamma value to apply
pars.threshold_value = 4.404793780967638 %% threshold value
pars.n_erosion_steps = 1%% number of steps to erode
pars.n_dilation_steps = 10%% number of steps to dialate
pars.min_region_size = 1

grade = 4;%% image grade, valid numbers are 0-4

Image = Image_gen(grade);
%%Image = normalise_image(Image)%% Konvertera bilddata till intervallet 0,1




[mask, threshold_value, ReturnImage] = threshold_signal_image(Image, pars); %% Kör threshold-funktionen och spara bara flattended_image
%%för att spara mask, eller annat, byt ut tilde mot en variabel.
 

%%Visa bilden före och efter att den processats
subplot(1,2,1);
    imshow(Image, 'InitialMag',100, 'Border','tight');
    


subplot(1,2,2);
    imshow(ReturnImage, 'InitialMag',100, 'Border','tight');
%%spara bilderna
% imwrite(sumimg, 'image.jpg');   
% imwrite(ReturnImage, 'processedimage.jpg');
