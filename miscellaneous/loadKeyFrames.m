function keyframes=loadKeyFrames(rootPath,scene)
%LOADKEYFRAMES Summary of this function goes here
%   Detailed explanation goes here
keyframes=[];
% keframes is available in the file rootPath/scenex/boxByFrame.txt 
fileName=rootPath  + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\boxByFrame.txt';
% rig2M=load(fileName);

fid = fopen( fileName );
cac = textscan( fid, '%d ', 'CollectOutput'  ...
                ,   true, 'Delimiter', ' '  );
[~] = fclose( fid );
rig2M=cac{1}(2:end);
N=length(rig2M);
rig2M2=reshape(rig2M,3,N/3)';

for i=1:size(rig2M2,1)
    initIdx=rig2M2(i,2);
    endIdx=rig2M2(i,3);
    for j=initIdx:endIdx
        keyframes=[keyframes j];
    end
end




end

