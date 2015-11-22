generate_synthetic = true;

data_path =  'C:\Users\Jens\Desktop\adipose_biopsy';
if exist(data_path, 'dir') && ~generate_synthetic    
    filenames = make_file_list(data_path, '*.raw');
    nfiles = numel(filenames);
else
    filenames = {};
    nfiles = 30;
end


%These are the values that were problematic. When casting to integer types,
%the second one will be trucated to zero of course...
vals = [10, 10];
threshold_vals = {};
threshold_vals{end+1} = vals;
threshold_vals{end+1} = uint8(vals);
threshold_vals{end+1} = uint16(vals);
threshold_vals{end+1} = single(vals);


pars = struct;
pars.normalisefl = false; 
pars.method = 'manual'; 
pars.n_erosion_steps = 0; 
pars.n_dilation_steps = 0;
pars.min_region_size = ceil(size(imgdata, 1)*size(imgdata, 2)*0.001); 
pars.flatten_mode = 'max'; 
pars.gammaval = 0.5; 
%%pars.threshold_value = 25 %% threshold value


%if we have to generate synthetic image, set parameters here
nrows = 300;
ncols = 400;
imsize = [nrows, ncols]; 
density = 5e-2;
grades = 0:4; 
types = {'adipose', 'hFTAA'}; 
% This is the path to the reference spectra, set it to wherever they are on
% your machine
datapath = 'C:\Users\Jens\OneDrive\Dokument\tools-dist v2\tools-dist v2\reference_spectra'; 
reference_spectra = load_reference_spectra(datapath, types);


for k=1:nfiles
    if ~isempty(filenames)
        [imgdata, metadata] = readASIraw(filenames{k});
    else
        grade = randperm(5, 1)-1;
        imgdata = make_synth_adipose_image(reference_spectra, [], density, grade, imsize);
    end
        
    rgbimg = multispect2rgb(imgdata);
    
    imgdata = double(imgdata);
    
    % Threshold image manually using one of the thresholds at random
    ridx1 = randperm(numel(threshold_vals), 1);
    ridx2 = randperm(numel(threshold_vals{ridx1}), 1);
    pars.threshold_value = threshold_vals{ridx1}(ridx2);
    mask = threshold_signal_image(imgdata, pars);
    mask = repmat(mask, [1 1 3]);
    
    %Check type
    dummy = pars.threshold_value;
    info = whos('dummy');    
    
    figure(1563);    
    imagesc([rgbimg.*mask mask]);axis image;    
    title(['Manual threshold, value: ' num2str(pars.threshold_value) ', type: ' info.class]);
    drawnow;
end