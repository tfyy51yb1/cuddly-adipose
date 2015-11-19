%%parametrar: refspectra (olika för diverse moduler?), pars (kolla för
%%varje modul, dessa ska placeras under parametersektionen nedan)
%%value = (grad eller ålder (?))
%%skapa modul för att välja till bilder eftersom(?)
%refpath fås genom path_refpath, [path filename] kommer ifrån path_filename
%refspectra och img (?) ----- spect_img(?), mask är output från threshold_.
%training_data fås genom init_database och 'descriptor' från uträkningen
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%++++++++++++++++++++++ Fasta parametrar nedan: +++++++++++++++++++++++++++
%
%
types = {'adipose', 'hfTAA'};
%value = '?'
%mode = eg. 'classify' or 'estimate'
%pars (till varje enskild modul som har detta som input)
%
%+++++++++++++++++++++ Nedan gäller pipeline (Databas): +++++++++++++++++++
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
path_filename(); 
path_refspectra(); 
init_database(refspectra, mode, pars);
readASIraw([path filename]);
load_ref_spectra(types,refpath);
%Modul för deskriptorberäkning här som innefattar:
%threshold_signal_image(img, pars);
%fit_spec_coeff(spect_img,refspectra,mask, pars);
%calc_foreground_histogram(img, mask);
%~~~~~~~~~~~>resultatet för denna modul blir 'descriptor'
insert_sample(training_data, descriptor, value);

%+++++++++++++++++ Nedan gäller pipeline (Matchning): +++++++++++++++++++++
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
readASIraw([path filename]);
load_reference_spectra(types, refpath);
%Modul för deskriptorberäkning här som innefattar:
%threshold_signal_image(img, pars);
%fit_spec_coeff(spect_img,refspectra,mask, pars);
%calc_foreground_histogram(img, mask);
%resultatet för denna modul blir 'descriptor'
match_sample(training_data, descriptor);
%%~~~~~~~~~~~~~~~~~>Resultat:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

