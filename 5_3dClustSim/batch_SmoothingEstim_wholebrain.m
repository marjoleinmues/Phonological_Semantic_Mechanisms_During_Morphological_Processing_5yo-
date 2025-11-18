%%% Script to run 3dFMHMx over loop of subjects. It will display the average values from the subjects at the end.
%%% You can also choose to write out the values for each subject into a
%%% text file. The last line will be the average values. You can also
%%% choose to run 3dclustsim directly from this script and the average
%%% values will be automatically entered in. 
%%Created by : Jessica Younger 7/9/16 
%Modified by Marjolein Mues 9/23/2024

addpath(genpath('/panfs/accrepfs.vampire/data/booth_lab/LabCode/typical_data_analysis/spm12'));
%addpath(genpath('/dors/gpc/JamesBooth/JBooth-Lab/BDL/fmriTools'));

spm_defaults;
spm('defaults','fmri');

% make sure the scriptdir is in the path
addpath(pwd);

% What directory has all your subject folders? We assume that in each subject folder is
% a folder containing the SPM.mat file for that subject's 1st level analysis
rootDIR  = '/panfs/accrepfs.vampire/data/booth_lab/Marjolein/Morph_5/preprocessed';

%What directory holds the model file for each subject
modelDIR  = 'ses5_analysis_gram/deweight';

%List your subjects 
namesubjects={'sub-5006', 'sub-5008', 'sub-5009', 'sub-5013', 'sub-5015', 'sub-5017', 'sub-5029', 'sub-5034', 'sub-5036', 'sub-5045', 'sub-5051', 'sub-5054', 'sub-5055', 'sub-5061', 'sub-5065', 'sub-5069', 'sub-5070', 'sub-5071', 'sub-5074', 'sub-5075', 'sub-5077', 'sub-5095', 'sub-5099', 'sub-5102', 'sub-5108', 'sub-5109', 'sub-5117', 'sub-5125', 'sub-5139', 'sub-5140', 'sub-5141', 'sub-5148', 'sub-5153', 'sub-5159', 'sub-5161', 'sub-5167', 'sub-5169', 'sub-5199', 'sub-5215', 'sub-5259', 'sub-5270', 'sub-5286', 'sub-5304', 'sub-5325', 'sub-5328', 'sub-5336', 'sub-5338', 'sub-5352'};

%3dcluststim options
threedclust=1; %Run 3dclustsim with results? 1 for yes, 0 for no
pthr = [.005]; %enter values for pthr .05 .01
ROI = '/panfs/accrepfs.vampire/data/booth_lab/Marjolein/Morph_5/secondlevel_gram_sr/Gram_Fin_Cont/spmT_0003.nii'; %pathway to your ROI

%Writing options to have the matrix of ACF values for each subject written
%out. The last lnie will be the average values to use in 3dclustsim
write=1; %write the individual subject information? 1 yes 0 no
writeDIR  = rootDIR; % Where do you want the text file  to be written?
filename = 'analysis_3dclust_wb';

%%%%%Do not edit below this line%%%%

numsubjects = length(namesubjects);
C=zeros(numsubjects,3);
idx = 1;
subj = 1:numsubjects;
 for x = subj
    swd = [rootDIR filesep char(namesubjects(x)) filesep modelDIR];
    %change to the subjects directory
    cd(swd);
    %run 3dFWHMx and store values
    diary('output.txt')
    %system(['3dFWHMx -detrend -ACF -mask mask.hdr -input ResMS.hdr -out
    %temp']); %Jin changed it here to make it compatable with
    %spm12. 5/3/2019
    system(['3dFWHMx -detrend -ACF -mask mask.nii -input ResMS.nii -out temp']);
    diary off
    temp1=textread('output.txt', '%s', 'delimiter', '\n');
    temp2=temp1(13,1);
    temp2=char(temp2);%     C(idx,1) = str2num(temp2(1:8));
%     C(idx,2) = str2num(temp2(10:17));
%     C(idx,3) = str2num(temp2(19:25));
    temp3=strsplit(temp2); %Jin changed here to make it easier to recognize the values
    C(idx,1) = str2num(temp3{1});
    C(idx,2) = str2num(temp3{2});
    C(idx,3) = str2num(temp3{3}); 
    idx = idx+1;
 end
 
 %Get mean ACF values
avgA = mean(C(:,1));
avgC = mean(C(:,2));
avgF = mean(C(:,3));
 
C(1+numsubjects, :) = [avgA, avgC, avgF];

if write==1
    fextension='.txt';
    cd(writeDIR);
    writefile=char([char(filename) char(fextension)]);
    dlmwrite(writefile, C, 'delimiter', '\t', '-append');
 end
diary 3dClustSim_Tables
if threedclust==1
system(['3dClustSim -pthr ' num2str(pthr) ' -mask ' ROI ' -ACF ' num2str(avgA) ' ' num2str(avgC) ' ' num2str(avgF)]);
end

Values=[avgA, avgC, avgF];
display(Values)
diary off
