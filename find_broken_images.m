images = get_Images;
fel = [];
for k=1:numel(images)
    try
        readASIraw(images{k});
    catch
        sprintf('%s\n', images{k})
    end
end
