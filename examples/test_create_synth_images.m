% This script shows how to generate synthetic test data
% Make sure to add the tools-dist path to the MATLAB search path.
% This can be done with 
% addpath(genpath(<path to tools>));
% However, doing this multiple times may cause newer MATLAB versions to
% freeze - I do not know why.

%% Create synthetic images, adipose set
% NB: in this setting, the grade value affects the average spectrum of the
% image. A grade 0 is pure adipose tissue, and its spectrum is the same as the adipose reference.
% A grade 4 has lots of amyloid deposits, and binds to hFTAA, making its
% spectrum much more similar to the hFTAA spectrum.

nrows = 300; %make images have 300 rows (Y)
ncols = 400; %make images have 400 columns (X)
imsize = [nrows, ncols]; % build size vector;
density = 5e-2; %medium-dense images (see documentation for good values)
grades = 0:4; % test one image of each grade
types = {'adipose', 'hFTAA'}; % These are the spectra to use for this type of image

% This is the path to the reference spectra, set it to wherever they are on
% your machine
datapath = 'C:\Users\Jens\Downloads\tools-dist v2\tools-dist\reference_spectra\'; 

reference_spectra = load_reference_spectra(datapath, types);

for k=1:numel(grades) % for every grade value
    imgdata = make_synth_adipose_image(reference_spectra, [], density, grades(k), imsize);
    testimg = multispect2rgb(make_synth_adipose_image(reference_spectra, [], density, grades(k), imsize));
    % collapse image by summing over all bands
    sumimg = sum(imgdata, 3);       
    % get average spectrum of all pixels by averaging over Y and X
    avg_spectrum = mean(mean(imgdata, 1), 2);
    % turn into a row vector so we can plot it
    avg_spectrum = permute(avg_spectrum, [1 3 2]);
    % dividing by exposure (metadata.exp) time should normalise correctly, but it doesn't
    % normalise so that energy is 1
    avg_spectrum = avg_spectrum/sqrt(sum(avg_spectrum.^2));
    
    % display
    figure(1);clf;
    subplot(2, 1, 1);
    imagesc(testimg);axis image;colormap default;colorbar;
    imagesc(imgdata);axis image;colormap default;colorbar;
    xlabel('X');
    ylabel('Y'); 
    title(['Sum of emission spectra, grade ' num2str(grades(k))], 'FontSize', 15);
    subplot(2, 1, 2);
    hold on;
    h1 = plot(avg_spectrum, 'r-', 'LineWidth', 2);
    h2 = plot(permute(reference_spectra{1}{1}, [1 3 2]), 'b--');
    h3 = plot(permute(reference_spectra{2}{1}, [1 3 2]), 'r--');
    hold off;
    legend([h1 h2 h3], cat(2, 'image', types));
    xlabel('Spectral band');
    ylabel('Avg. emission');
    title('Average spectrum of image');
    drawnow;    
    % pause and wait for key press
    pause;
end


%% Create synthetic images, brain tissue set
% NB: in this setting, the age value does not change the spectral
% statistics of the image. The radial distribution around the
% plaque cores changes, but this cannot be seen in the average spectrum.

nrows = 300; %make images have 300 rows (Y)
ncols = 400; %make images have 400 columns (X)
imsize = [nrows, ncols]; % build size vector;
density = 2e-4; %medium-dense images (see documentation for good values)
agevals = 5:23; % test one image of each grade
types = {'hFTAA', 'qFTAA'}; % These are the spectra to use for this type of image

% This is the path to the reference spectra, set it to wherever they are on
% your machine
datapath = '/home/wallenberg/SVN/TFYY51/2015-HT/tools-dist/reference_spectra'; 

reference_spectra = load_reference_spectra(datapath, types);

for k=1:numel(agevals) % for every age value
    imgdata = make_synth_plaque_image(reference_spectra, [], density, agevals(k), imsize);
    
    % collapse image by summing over all bands
    sumimg = sum(imgdata, 3);       
    % get average spectrum of all pixels by averaging over Y and X
    avg_spectrum = mean(mean(imgdata, 1), 2);
    % turn into a row vector so we can plot it
    avg_spectrum = permute(avg_spectrum, [1 3 2]);
    % dividing by exposure (metadata.exp) time should normalise correctly, but it doesn't
    % normalise so that energy is 1
    avg_spectrum = avg_spectrum/sqrt(sum(avg_spectrum.^2));
    
    % display
    figure(1);clf;
    subplot(2, 1, 1);
    imagesc(sumimg);axis image;colormap gray(256);colorbar;
    xlabel('X');
    ylabel('Y');
    title(['Sum of emission spectra, age: ' num2str(agevals(k))], 'FontSize', 15);
    subplot(2, 1, 2);
    hold on;
    h1 = plot(avg_spectrum, 'r-', 'LineWidth', 2);
    h2 = plot(permute(reference_spectra{1}{1}, [1 3 2]), 'b--');
    h3 = plot(permute(reference_spectra{2}{1}, [1 3 2]), 'r--');
    hold off;
    legend([h1 h2 h3], cat(2, 'image', types));
    xlabel('Spectral band');
    ylabel('Avg. emission');
    title('Average spectrum of image');
    drawnow;    
    % pause and wait for key press
    pause;
end
