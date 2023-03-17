function [meanfs, maxfs, minfs] = computeSamplingFreq(rootPath,scene)
%UNTITLED compute sampling frequency from hololens sensor. Outputs a mean
%sampling frequency computed from the sampling instants
%   Detailed explanation goes here


% load hololens ticks at sampling instants
fileName_r2w=[rootPath+'corrida'+num2str(scene)+'\HL2\Depth Long Throw_rig2world.txt'];
ticks_v=load(fileName_r2w);
% compute mean distance between adjacent ticks
for (i=1:length(ticks_v)-1)
    distance(i)=(ticks_v(i+1)-ticks_v(i))*1e-7;
end
meanDistance=mean(distance);
maxDistance=max(distance);
minDistance=min(distance);
% convert to Hz
meanfs=1/meanDistance;
maxfs=1/maxDistance; 
minfs=1/minDistance;

end

