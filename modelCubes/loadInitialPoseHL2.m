function T=loadInitialPoseHL2(rootPath,scene, frame)
%LOADINITIALPOSEHL2 Loads camera pose in mocap world
%   Returns distance in mm and angle in degrees

if nargin==2
    frame=1;
end


% T is available in the file rootPath/scenex/rig2mocap_1fps.txt 
fileName=rootPath  + 'scene' + num2str(scene) + '\rig2Mocap_1fps.txt';
rig2M=load(fileName);
T=assemblyTmatrix(rig2M(frame,2:14));%distances in mm

% 
% figure,
%     T0=eye(4,4);
%     Taux=T;
%     Taux(1:3,4)=Taux(1:3,4)/1000;
%     dibujarsistemaref(Taux,'h',1,1,10,'black')%(T,ind,scale,width,fs,fc)
%     hold on
%     dibujarsistemaref(T0,'m',1,1,10,'black')%(T,ind,scale,width,fs,fc)
%     grid on 
%     xlabel x
%     ylabel y
%     zlabel z
%     title 'frames q_h and q_m for scene x'


end

