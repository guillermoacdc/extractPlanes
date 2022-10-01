function centralSample = convertFrame2MocapSample(rootPath,scene,keyframe)
%CONVERTFRAME2MOCAPSAMPLE Summary of this function goes here
%   Detailed explanation goes here
[~,discardedinitMocapSamples,discardedendMocapSamples]=synchInitEndm_v4(rootPath, scene);
[~,discardedinitHSamples,discardedendHSamples]=synchInitEndh(rootPath,scene);

centralSample=uint64((keyframe-discardedinitHSamples)*(1/4)*960)+discardedinitMocapSamples;

end

