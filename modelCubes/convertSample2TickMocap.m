function tickValue = convertSample2TickMocap(rootPath,sample,scene,fs,ticksPerSec)
%CONVERTSAMPLE2TICKMOCAP Summary of this function goes here
%   Detailed explanation goes here
% fs=960
% ticksPerSec=1e7
% read init time and convert to ntfs
% 
% offsetH=5;
% offsetMin=0;
[offsetH, offsetMin] = computeOffsetSynch_raw(scene);
initTimeM_ntfs=computeInitMocap_ntfs(rootPath,scene,offsetH,offsetMin);

% compute output
stepScanning=ticksPerSec/fs;
tickValue=initTimeM_ntfs+((sample-1)*stepScanning);

end

