function [T ticksMocap] = computeTcandidatesAroundKeyFrame(scene,keyframe,rootPath,band,scale)
%COMPUTETCANDIDATESAROUNDKEYFRAME Compute the candidates of transformation
%matrix T around a hololens keyframe. The number of candidates is
%controlled by two inpunts
% 1. band. We expect 2*band candidates around the keysample_m 
% 2. scale. distance between adjacent samples

[keySample_m keytsh keytsm]=convertKeyFrameh2KeySamplem(keyframe,rootPath,scene);

candidateSamples_m=[keySample_m-round(band/2):scale:keySample_m+round(band/2)];
mocapStepTick=uint64(1/960*10e7);
ticksMocap=[keytsm-(round(band/2)*mocapStepTick):scale*mocapStepTick:keytsm+(round(band/2)*mocapStepTick)];

T=computeTm_c(scene, candidateSamples_m, rootPath);

end

