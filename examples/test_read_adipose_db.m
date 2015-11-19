% This script shows examples of reading and displaying raw images
% set pausefl to true if you want to pause after each image

pausefl = false;

% path to all the raw files
datapath = 'C:\Users\Jens\Desktop\adipose_biopsy';

% make a list of the files
files = make_file_list(datapath, '*.raw');

% from the file names, create a list of grades
grades = zeros(size(files));
for k=1:numel(files)
    % This assumes 'grade' does not appear in the path
    dummy = strsplit(files{k}, {'grade'});
    dummy = strsplit(dummy{end}, '_');
    grades(k) = str2double(dummy{1});
end

% sort file list by grade
[grades, sidx] = sort(grades, 'ascend');
files = files(sidx);

%%
% for each file, read and display
for k=1:numel(files)
    [imgdata, metadata] = readASIraw(files{k});
    
    % create false-colour RGB image
    rgbimg = multispect2rgb(imgdata);
    sumimg = sum(imgdata, 3);
    % get average spectrum of all pixels by averaging over Y and X
    avg_spectrum = mean(mean(double(imgdata), 1), 2);
    % turn into a row vector so we can plot it
    avg_spectrum = permute(avg_spectrum, [1 3 2]);
    % dividing by exposure (metadata.exp) time should normalise correctly, but it doesn't
    % normalise by maximum instead
    avg_spectrum = avg_spectrum/max(avg_spectrum);
    
    % display
    figure(1);clf;
    subplot(2, 2, 1);
    imagesc(sumimg);axis image;colormap gray;colorbar;
    xlabel('X');
    ylabel('Y');
    title(['Sum of emission spectra, image ' num2str(k)], 'FontSize', 15);
    subplot(2, 2, 2);
    imagesc(rgbimg);axis image;
    xlabel('X');
    ylabel('Y');
    title(['False-colour RGB image, grade ' num2str(grades(k))], 'FontSize', 15);
    subplot(2, 2, 3);
    plot(avg_spectrum, 'r-', 'LineWidth', 2);
    xlabel('Spectral band');
    ylabel('Avg. emission');
    title('Average spectrum of image');
    drawnow;
    
    disp(files{k});
    disp(metadata);
    % pause and wait for key press
    if pausefl
        disp('Press any key to continue...');
        pause;
    end
end