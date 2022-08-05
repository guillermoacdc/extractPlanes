function [tform_gt L1_gt L2_gt]=loadGTData(rootPath, scene, keybox);
%LOADGTDATA Summary of this function goes here
%   Detailed explanation goes here


% tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
fileName=rootPath  + 'scene' + num2str(scene) + '\Mocap_initialPoseBoxes.csv';
initialPosesT= readtable(fileName);
initialPosesA = table2array(initialPosesT);
row=find(initialPosesA(:,1)==keybox);
tform_gt=assemblyTmatrix(initialPosesA(row,2:14));

% Length information is in previousKnowledgeFile.txt
fileName=rootPath  + 'scene' + num2str(scene) +'\previousKnowledgeFile.txt';
lengthInfo=load(fileName);
row=find(lengthInfo(:,1)==keybox);

L1_gt=lengthInfo(row,4);
L2_gt=lengthInfo(row,5);

if L1_gt>L2_gt
    aux=L1_gt;
    L1_gt=L2_gt;
    L2_gt=aux;
end

end

