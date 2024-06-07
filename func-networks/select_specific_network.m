clc,clear

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
seed_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks';
session_list = dir('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/data/sub01');
session_list(1:2) = [];

roi_ids = importdata([main_dir, '/scripts/func_networks/masks/ROIs_300inVol_MNI/ROIs_CommunityAffiliation.txt']);
roi_func_network = find(roi_ids == 17);

seed_header = spm_vol([seed_dir, '/ROIs_300inVol_MNI/', 'ROIs_300inVol_MNI.nii']);
seed_mask = spm_read_vols(seed_header);

%https://www.researchgate.net/publication/284433813_Network-Level_Connectivity_Dynamics_of_Movie_Watching_in_6-Year-Old_Children#pf4

%DMN:
%precuneus 106
%frontal med orb L 108

%VISUAL
%calcarine L 156
%occipital mid L 150
%

%frontoparietal
%frontal mid L 183
%frontal inf tri L 180
%parietal inf L 175

%CO
%cingulum mid L 55
%thalamus R 266

%salience
%insula L 202
%cingulate anterior 204

%parietomedial
%cingulum post L 138

%VA
%putamen 257
%temporal mid L 212

%DA
%angular R 230
%frontal mid R 232

%MTL
%parahipocampo 237
%hipocampo 236

%iterar sobre cada roi perteneciente a la red
seed_mask_data = zeros(size(seed_mask));
for iRoi=1:length(roi_func_network)
    temp = seed_mask == roi_func_network(iRoi);
    seed_mask_data = seed_mask_data + temp;
end

h = seed_header;
h.fname = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks/ROIs_300inVol_MNI/power_mtl.nii';
spm_write_vol(h, seed_mask_data);