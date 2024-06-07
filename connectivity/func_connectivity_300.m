clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

roi = 'ROIs_300inVol_MNI';
n_rois = 300;
n_nets = 14;
func_networks_list = importdata([main_dir, '/scripts/func_networks/masks/ROIs_300inVol_MNI/ROIs_CommunityAffiliation.txt']);
func_networks_unique = unique(func_networks_list);

C = zeros(length(session_list), 4, n_rois, n_rois); %correlation per node
C_net = zeros(length(session_list), 4, n_nets, n_nets); %correlation per func network
C_intra = zeros(length(session_list), 4, n_nets);
C_inter = zeros(length(session_list), 4, n_nets);
for iSess=1:length(session_list)
    sessionName = session_list(iSess).name;
    
    display(sessionName)
    
   for iCond=1:4
    %correlation per node
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_roi.mat'])
    
    %ignoramos el primer volumen por los nans de la sesion 8
    if iSess == 8
       func_roi = func_roi(:, 2:end); 
    end
    
    C(iSess, iCond, :,:) = corr(func_roi', func_roi');
    
%     %correlation per func network
%     load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_network.mat'])
%     
%     %ignoramos el primer volumen por los nans de la sesion 8
%     if iSess == 8
%        roi_data = roi_data(:, 2:end); 
%     end
%     
%     C_net(iSess, iCond, :, :) = corrcoef(roi_data');
%     
%     
%     for iNet=1:n_nets
%         func_networks_idx = func_networks_list == iNet;
%         %intra connectivity
%         nodes_func_network = func_roi(func_networks_idx, :);
%         C_intra(iSess, iCond, iNet) = mean(mean(corrcoef(nodes_func_network')));
% 
%         %inter connectivity
%         nodes_not_func_network = func_roi(~func_networks_idx, :);
%         C_inter(iSess, iCond, iNet) = mean(mean(corr(nodes_func_network', nodes_not_func_network')));
%     end
    
   end
end

save([main_dir, '/results/connectivity/300/connectivity_333.mat'], 'C')
save([main_dir, '/results/connectivity/300/connectivity.mat'], 'C_net')
save([main_dir, '/results/connectivity/300/intra_connectivity.mat'], 'C_intra')
save([main_dir, '/results/connectivity/300/inter_connectivity.mat'], 'C_inter')

C_net_2 = zeros(20, 4, n_nets, n_nets);
for iSess=1:20
    for iCond=1:4
        for i=1:n_nets
            for j=1:n_nets
                c = C(iSess, iCond, func_networks_list==func_networks_unique(i), func_networks_list==func_networks_unique(j));
                C_net_2(iSess, iCond, i, j) = mean(c(:));
            end
        end
    end
end

save([main_dir, '/results/connectivity/300/connectivity_2.mat'], 'C_net_2')

%% difference between conditions over the 300 x 300 matrix
C_trans = squeeze(mean(C(:, 2, :, :) - C(:, 1, :, :), 1));
C_alter = squeeze(mean(C(:, 3, :, :) - C(:, 1, :, :), 1));
C_recup = squeeze(mean(C(:, 4, :, :) - C(:, 1, :, :), 1));

header_atlas = spm_vol('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks/ROIs_300inVol_MNI/ROIs_300inVol_MNI.nii');
data = spm_read_vols(header_atlas);

for iRoi=1:300
    data(data == iRoi) = mean(C_trans(iRoi,:));
end

new_header = header_atlas;
new_header.fname = 'test.nii';
spm_write_vol(new_header, data);