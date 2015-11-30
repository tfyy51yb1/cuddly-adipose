%generate synthetic images and save them in .mat files
%j is a vector, its size determines wich grades to generate. lowest:highest
%num_of_images determines how many images of each grade is to be generated
%this function requires the user to enter the correct path to reference spectra in Image_gen 

%%
%settings
for j=0:4
    Grade = j; % image grade, use interval 0-4
    num_of_images = 4; % number of images
    mkdir('Dataset');

    for k=1:num_of_images
        imgdata = Image_gen(Grade);
        name = ['Dataset/Grade' num2str(Grade) '_image_' num2str(k) '.mat'];
        save(name, 'imgdata');
    end
end
disp('Done!')