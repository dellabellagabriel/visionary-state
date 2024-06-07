clear,clc;

addpath /home/usuario/disco1/toolboxes/BCT/2019_03_03_BCT

%sub_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/func_networks/ROIs_300inVol_MNI_controles';
%n_subs = 10;

sub_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/func_networks/ROIs_300inVol_MNI';
n_subs = 20;


sub_list = dir(sub_dir);
sub_list(1:2) = [];

range_perc = 85;
sw = zeros(n_subs,4,length(range_perc));
for iSub=1:length(sub_list)
   for iCond=1:4
        load([sub_dir, '/', sub_list(iSub).name, '/cond', num2str(iCond), '/func_roi_288.mat'])
        c = corrcoef(func_roi');
        c(logical(eye(288))) = 0;
        for iPerc=1:length(range_perc)
            fprintf('sujeto %i, cond %i, percentil %f \n', iSub, iCond, range_perc(iPerc));
            bin_c = double(c > prctile(c(:), range_perc(iPerc)));
            D = distance_bin(bin_c);

            sw(iSub, iCond, iPerc) = small_worldness(bin_c);
        end
   end
end
figure
bar(nanmean(sw))
hold on
errorbar(nanmean(sw), nanstd(sw)/sqrt(n_subs), '.')
%ylim([0.3 0.35])
%title('global efficiency (integration)')