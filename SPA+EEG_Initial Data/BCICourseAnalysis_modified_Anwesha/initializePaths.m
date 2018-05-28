function initializePaths()
    global verbose;
    if verbose
       disp('Initialize paths'); 
    end
    close all;
    addpath(genpath('biosig'))
    addpath(genpath('eeglab13_4_4b'))
    addpath(genpath('resources'))
    addpath(genpath('classification'))
    rmpath(genpath('eeglab13_4_4b/functions/octavefunc'))
    addpath(genpath('E:\WORKSPACE\EPFL\vibrotactile_cnbi\SPA experiments data\data_eeg_example_files'))
end