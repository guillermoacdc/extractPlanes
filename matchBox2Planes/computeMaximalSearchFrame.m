function mxSearchFrame=computeMaximalSearchFrame(rootPath,scene,boxID)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% mxSearchFrame=[];
% mxSearchFrame is available in the file rootPath/scenex/boxByFrame.txt 
% fileName=rootPath  + 'scene' + num2str(scene) + '\boxByFrame.txt';
fileName=rootPath  + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\boxByFrame.txt';
fid = fopen( fileName );
cac = textscan( fid, '%d ', 'CollectOutput'  ...
                ,   true, 'Delimiter', ' '  );
[~] = fclose( fid );
rig2M=cac{1}(2:end);
N=length(rig2M);
rig2M2=reshape(rig2M,3,N/3)';

index=find(rig2M2(:,1)==boxID);
mxSearchFrame=rig2M2(index,:);%[boxID initFrame endFrame]

end

