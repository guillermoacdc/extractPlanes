% compute scanning time from frames
clc
close all
clear 

rootPath="G:\Mi unidad\boxesDatabaseSample\";
% load scene ids
sceneIDs_t=readtable([rootPath + 'misc\Guillermo_ScenesWithLowOcclusion.txt']);
sceneIDs_a=sceneIDs_t.Var1;
sceneIDs = sceneIDs_a(~isnan(sceneIDs_a))';


for i=3:length(sceneIDs)
    scene=sceneIDs(i);
% load mocap frames
    fileName_mf=[rootPath+'corrida'+num2str(scene)+'\mocap\initialPose1.csv'];
    mocapFrames_t=csvread(fileName_mf);
    mocapFrames=mocapFrames_t(1,2);
    mocapFramesV(i)=mocapFrames;
% computing hl2 delta ticks
    fileName_r2w=[rootPath+'corrida'+num2str(scene)+'\HL2\Depth Long Throw_rig2world.txt'];
    ticks_v=load(fileName_r2w);
    deltaTicks=(ticks_v(4,1)-ticks_v(3,1))*1e-7;
% load hl2 frames
    fileName_hf=[rootPath+'corrida'+num2str(scene)+'\HL2\pinhole_projection\depth.txt'];
    hlFrames_l=readlines(fileName_hf);
    hlFrames=length(hlFrames_l);
    hlFramesV(i)=hlFrames;
    txt=[num2str(scene), ' ' ,num2str(mocapFrames), ' ' ,...
    num2str(hlFrames), ' ' ,num2str(mocapFrames/960), ' ' ,num2str(hlFrames/4)];
%     display (scene);
end
review=[sceneIDs' mocapFramesV' hlFramesV' mocapFramesV'/960 hlFramesV'/4 (mocapFramesV'/960)./(hlFramesV'/4)];
% compute time from frames

% display results