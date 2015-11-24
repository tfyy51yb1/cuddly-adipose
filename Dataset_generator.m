%generate synthetic images and save them in .mat files

%%
%settings
Grade = 4; % image grade, use interval 0-4
num_of_images = 2; % number of images
mkdir('Dataset');

for k=1:num_of_images
    imgdata = Image_gen(Grade);
    name = ['Dataset/Grade' num2str(Grade) '_image_' num2str(k) '.mat'];
    save(name, 'imgdata');
end
disp('Done!')