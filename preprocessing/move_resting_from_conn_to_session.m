%This script moves the files generated by CONN into the corresponding session folder (in func-resting)
%CONN concatenates conditions so there's a single file per session

conn_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/preprocesamiento/conn/states-fmri/results/preprocessing';
conn_files = dir([conn_dir,'/niftiDATA_Subject*']);

sessions_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/data/sub01';
session_files = dir(sessions_dir);
session_files(1:2) = []; %remove . and ..

for i=20:length(session_files)
   display(['Copying session ', num2str(i), ' ...'])
   copyfile([conn_dir,'/',conn_files(i).name], [sessions_dir,'/',session_files(i).name,'/func-resting/']) 
   movefile([sessions_dir,'/',session_files(i).name,'/func-resting/',conn_files(i).name], [sessions_dir,'/',session_files(i).name,'/func-resting/',session_files(i).name,'-resting.nii'])
end