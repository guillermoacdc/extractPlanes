clc
close all
clear 



scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
frames=[1:165];
er=[];
et=[];
for i=1:size(frames,2)
    frame=frames(i);
    % load camera pose from mocap. Requires rig2mocap_1fps.txt 
    Tcm=loadInitialPoseHL2(rootPath,scene, frame);%length is loaded in mm from mocap recordings
    % load camera pose from hololens. Requires Depth Long Throw_rig2world.txt
    Tch=loadInitialPoseHL2FromHL2(rootPath,scene, frame);%length is loaded in mt.
    Tchmm=Tch;
    Tchmm(1:3,4)=Tchmm(1:3,4)*1000;
    
    % compute transformation matrix by creuss
    Thm = myTsolver_creuss(Tchmm,Tcm);%mm
    % project Tchmm to qm
    Tprojected=Tchmm*Thm;
    [et1,er1] = computeSinglePoseError(Tprojected,Tcm);
    er=[er er1];
    et=[et et1];
end


% plot results

figure,
stem(et)
grid on
ylabel 'e_t'

return

    T0=eye(4,4);
    Taux=Tprojected;
    Taux(1:3,4)=Taux(1:3,4)/1000;
    Tcmaux=Tcm;
    Tcmaux(1:3,4)=Tcmaux(1:3,4)/1000;




figure,

    dibujarsistemaref(Taux,'c_{p}',1,1,10,'black')%(T,ind,scale,width,fs,fc)
    hold on
    dibujarsistemaref(Tcmaux,'c',1,1,10,'black')%(T,ind,scale,width,fs,fc)
    dibujarsistemaref(T0,'m',1,1,10,'black')%(T,ind,scale,width,fs,fc)
    grid on 
    xlabel x
    ylabel y
    zlabel z
    title 'frames q_h and q_m for scene x'




