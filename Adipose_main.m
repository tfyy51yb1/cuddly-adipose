%%Adipose Main



%%---------------------------------------
%%Run-once supporting functions
%%---------------------------------------


%%get a list of images
images = get_Images(); 

%%get reference spectra
refspectra = get_refspectra();
%%---------------------------------------
%%pipeline loop
%%---------------------------------------
for k=1:numel(images)
  histogram = descriptor_calc(images{k}, refspectra)
end