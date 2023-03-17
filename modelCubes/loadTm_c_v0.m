function [T time] = loadTm_c(rootPath,scene,frame, offset_synch)
%LOADTH_C Load Transformation from camera to qh for an specific frame.The
%output is composed by two variables
% T is the transformation matrix with lengths in mm and in the format
% ....
% time is the timestamp in ntfs


fileName=rootPath  + 'scene' + num2str(scene) + '\rig2Mocap_offset' + num2str(offset_synch) + '.txt';
rig2M=load(fileName);

T=assemblyTmatrix(rig2M(frame,2:13));%distances in mm
time=rig2M(frame,1);%time in ms

end



