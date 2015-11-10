%%Adipose Main



%%---------------------------------------
%%Run-once supporting functions
%%---------------------------------------


%%get a list of real images
%images = get_Images(); 

%use synthetic dataset
%images = get_Dataset
%%get reference spectra
refspectra = get_refspectra();
%%---------------------------------------
%%pipeline loop
%%---------------------------------------
for k=1:numel(images)
 histogram = descriptor_calc(images{k}, refspectra)
end