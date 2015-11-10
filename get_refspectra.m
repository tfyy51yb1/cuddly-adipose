function reference_spectra = get_refspectra();

%%Type of spectra to load
types = {'adipose'};


%%generate path to folder containing spectra
Current_folder = pwd; 
refSpectraSubPath = '\reference_spectra';
datapath = strcat(pwd, refSpectraSubPath);

%%load reference spectra and return
reference_spectra = load_reference_spectra(datapath, types);
end