function refspectra = load_reference_spectra(path, types)

sets = {'adipose', 'qFTAA', 'hFTAA'};

indices = zeros(size(types));
for k=1:numel(types)
    indices(k) = strmatch(types{k}, sets);
end

refspectra = {};

for k=indices
    data = load([path '/' sets{k} '/refspectrum.mat']);    
    sizes = zeros(1, numel(data.avg_spectrum));
    for n=1:numel(sizes)
        sizes(n) = numel(data.avg_spectrum{n});
        data.avg_spectrum{n} = data.avg_spectrum{n}/sqrt(sum(data.avg_spectrum{n}.^2, 3));
    end
    [~, sidx] = sort(sizes, 'ascend');
    refspectra{end+1} = data.avg_spectrum(sidx);
end

disp(['Loaded reference spectra for types: ', strjoin(sets(indices), ', ')]);