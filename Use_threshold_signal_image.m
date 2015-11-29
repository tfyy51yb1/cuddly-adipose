


    %%test function
    %%however, Threshold_signal_image does not accept threshold values representet with more than one character. eg, 10 or 0,1

function [mask, threshold_value, ReturnImage] = Use_threshold_signal_image(Image)

%%set up parmameter struct
global threshold_pars
threshold_pars = struct;
threshold_pars.flatten_mode = 'max'; %% 'sum' or 'max'
threshold_pars.normalisefl = false; %%true/false
threshold_pars.method = 'manual'; %% manual/automatic
threshold_pars.gammaval = 0.7; %%gamma value to apply
threshold_pars.threshold_value = 130; %% threshold value
threshold_pars.n_erosion_steps = 0;%% number of steps to erode
threshold_pars.n_dilation_steps = 0;%% number of steps to dialate
threshold_pars.min_region_size = ceil(size(Image, 1)*size(Image, 2)*0.001);



[mask, threshold_value, ReturnImage] = threshold_signal_image(Image, threshold_pars); %% Kör threshold-funktionen och spara bara flattended_image
