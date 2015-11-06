%% Adipose Main
clear;close all;clc;
cd 'C:/Users/Jens/Documents/GitHub/cuddly-adipose/'
%%
%%---------------------------------------
%%Run-once supporting functions
%%---------------------------------------


%% get a list of images
images = get_Images(); 

%% get reference spectra
refspectra = get_refspectra();
y=refspectra{1};
y=y{1,1,:};
y=y(:);
figure();plot(y);

%% ---------------------------------------
%%pipeline loop
%%---------------------------------------
for k=1:numel(images)
  histogram = descriptor_calc(images{k}, refspectra)
end