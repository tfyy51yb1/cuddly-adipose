% function training_data = init_database(refspectra, pars, mode)
% This function creates a training dta structure which can be used to store
% descriptors for matching.
% 
%
% INPUT
% refspectra    reference spectra for probes
% pars          parameter struct used to compute image descriptors and
%               match samples to database
% mode          string, 'classify', or 'estimate'
%                    
%
% OUTPUT
% training_data     struct for storing image descriptors with fields:
%                        vals: values for training images (grades or ages)
%                        (empty)
%                        refspectra: reference spectra
%                        descriptors: descriptors for training images
%                        (empty)
%                        pars: parameters used to calculate descriptors and
%                        match images
%
% Marcus Wallenberg, 2015
function training_data = init_database(refspectra, pars, mode)

training_data = struct;
training_data.vals = [];
training_data.refspectra = refspectra;
training_data.descriptors = {};
training_data.pars = pars;
training_data.mode = mode;
