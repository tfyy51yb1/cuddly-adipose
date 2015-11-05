%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%skapar en path dit refspectrat ligger, av användarens val
refpath = uigetdir('C:\');
%%används främst i funktionen load_ref_spectra där 'refpath' är input.
%%Anropas i main.m och låter väljaren att efter ha valt bildfiler att välja
%%mappen för refspectrat.
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MG~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~