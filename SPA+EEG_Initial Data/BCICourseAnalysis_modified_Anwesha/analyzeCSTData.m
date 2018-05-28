addpath(genpath('biosig'))
addpath(genpath('/home/cnbi/data/BCICourse/tif/2offline/'))
addpath(genpath('/home/cnbi/data/BCICourse/tif/trials/2offline/'))


filenames = {'tif.20180307.140439.offline.mi.mi_cst.gdf'};
[data, header] = sload(filenames{1});