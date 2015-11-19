%generate synthetic images and save them in .mat files

%%
%settings
Grade = 1; % image grade, use interval 0-4
num_of_images = 10; % number of images
mkdir('Dataset');

for k=1:num_of_images
    imgdata = Image_gen(Grade);
    name = ['Dataset/image_' num2str(k) '_grade_' num2str(Grade) '.mat'];
    save(name, 'imgdata');
end
