function tickOutput = convertKeyFrameh2MocapTick(keyframe,rootPath,scene)
%CONVERTKEYFRAMEH2MOCAPTICK This function converts a keyframe from hololens to
%a tick stamp in mocap sensor
%   Detailed explanation goes here

% compute discarded sample at init hololens
[~,discardedinitHSamples]=synchInitEndh(rootPath, scene);%returns a matrix 
if (keyframe<discardedinitHSamples)
    disp( ['Error. your key sample is lower than the discarded initHSamples=' num2str(discardedinitHSamples)] )
end

% compute mocap ticks and samples in syncrhonized times
[mocapTimes, discardedinitMocapSamples]=synchInitEndm_v4(rootPath, scene);% returns 

% compute sample at mocap, associated with the keyframe at hololens
mocapSample=((keyframe-discardedinitHSamples)*960/4) + discardedinitMocapSamples;

tickOutput=mocapTimes(mocapSample,:);
end

