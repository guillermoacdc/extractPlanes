function [keySample keytsh keytsm]=convertKeyFrameh2KeySamplem(keyframe,rootPath,scene)
% This function converts a key frame from hololens to a keysample in mocap

% syncrhonize init and end of hololens timestamps
HololensTicks=synchInitEndh(rootPath, scene);%returns a matrix 
% with N rows and two columns: [frame_h, timestamp_h]

% syncrhonize init and end mocap samples and convert mocap samples to timestamps
MocapTicks=synchInitEndm_v4(rootPath, scene);% returns 
% a matrix with Nm rows and two columns: [samples_m, timestamp_m]

% look for nearest timestamp in mocap and convert it to keySample

    index=find(HololensTicks(:,1)==keyframe);
    closestIndex=computeClosestIndex(HololensTicks(index,2),MocapTicks(:,2));
    keySample=MocapTicks(closestIndex,1);
    keytsh=HololensTicks(index,2); 
    keytsm=MocapTicks(closestIndex,2);

