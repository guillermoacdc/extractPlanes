function sample = convertTick2SampleMocap(rootPath,tick,scene,fs,ticksPerSec)
%CONVERTTICK2SAMPLEMOCAP Summary of this function goes here
%   Detailed explanation goes here
%     offsetH=5;
%     offsetMin=0;
    [offsetH, offsetMin] =computeOffsetSynch_raw(scene);
    initTimeM_ntfs=computeInitMocap_ntfs(rootPath,scene,offsetH,offsetMin);
    
    % compute output
    stepScanning=ticksPerSec/fs;
    sample=(tick-initTimeM_ntfs)/stepScanning + 1;
%     sample=(tick)/stepScanning + 1;
end

