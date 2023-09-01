function [descriptorVector_out] = projectDescriptorToRelativePose(descriptorVector_in,sessionID, frameID)
%PROJECTDESCRIPTORTORELATIVEPOSE Summary of this function goes here
%   Detailed explanation goes here

% load reference pose
fileName='referencePose_qh.json';
folderPath=computeMainPaths(sessionID);
filePath=fullfile(folderPath,'misc');
jsonData=loadJSONfile(fileName, filePath);
Th2ref=jsonData.(['session' num2str(sessionID)]).tform;
% process Th2ref with T1 and T2 before compute inverse
Th2ref=rotH2M(Th2ref);
Tref2h=inv(Th2ref);
% project estimated poses
Nb=size(descriptorVector_in.IDObjects,1);
modelParameters=zeros(1,7);
pathInliers=[];
Nmbinliers=[];
for i=1:Nb
    %     descriptorVector_out(i).tform=descriptorVector_in(i).tform*Tref2h;
    T= assemblyTmatrix(descriptorVector_in.poses(i,:));
%     process T with T1 and T2 before compute Tu
    T=rotH2M(T);
    Tu=T*Tref2h;
    pID=descriptorVector_in.IDObjects(i,:);
    if pID(1)==0
        frameID=0;
    end
    descriptorVector_out(i)=plane(sessionID,frameID,pID(2),modelParameters,pathInliers,Nmbinliers);
    descriptorVector_out(i).tform=Tu;
    descriptorVector_out(i).L1=descriptorVector_in.L1(i);
    descriptorVector_out(i).L2=descriptorVector_in.L2(i);
end

end

