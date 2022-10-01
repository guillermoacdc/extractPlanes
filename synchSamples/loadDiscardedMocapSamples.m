function discardedMocapSamples=loadDiscardedMocapSamples(rootPath,scene)
%LOADDISCARDEDMOCAPSAMPLES returns the number of discarded mocap samples at
%init of the scanning.
%   Detailed explanation goes here

% C:\lib\boxTrackinPCs\misc
synchDescriptors=importdata(rootPath + '\misc\synchDescriptors_1fps.txt');
sensorName=synchDescriptors.textdata(scene,5);

if strcmp(char(sensorName),'mocap ')
    discardedMocapSamples=uint64(str2num(char(synchDescriptors.textdata(scene,6))));
else
    discardedMocapSamples=0;
end


end

