function [et, er, eL1, eL2]=computePoseError(localPlanes, keyPlaneTwins,...
    Th, Tbox_gt, L1_gt, L2_gt)
% index 1 is used for estimated variable
% inex 2 is used for reference variable

t2=Tbox_gt(1:3,4)*1000;%in mm
R2=Tbox_gt(1:3,1:3);%in rads or in degrees
et=[];
er=[];
eL1=[];
eL2=[];

Nt=size(keyPlaneTwins,1);


Trotx180=eye(4);
Trotx180(1:3,1:3)=rotx(180);
Trotz_90=eye(4);
Trotz_90(1:3,1:3)=rotz(-90);
T_h2m=Trotz_90*Trotx180*Th;%mm

% Tz90(1:3,1:3)=rotz(90);
for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
    Tbox=currentTwin.tform;%distance in mt, angles in rad or degrees
    
%   convert meters to mm
    Tbox_mm=Tbox;
    Tbox_mm(1:3,4)=Tbox_mm(1:3,4)*1000;%
    % project Tbox to qm
    Tbox_mm_m=Tbox_mm*T_h2m;

    t1=Tbox_mm_m(1:3,4);
    R1=Tbox_mm_m(1:3,1:3);
    aux=acos((trace(R1'*R2)-1)/2);
    et=[et norm(t1-t2)];
    er=[er aux];
    eL1=[eL1 abs(L1_gt-currentTwin.L1*100)];
    eL2=[eL2 abs(L2_gt-currentTwin.L2*100)];
end

    T0=eye(4,4);%origin of mocap
%     convertion of Th to meters
    Th_mt=Th;
    Th_mt(1:3,4)=Th_mt(1:3,4)/1000;
    %convertion of Tbox_m to meters
    Tbox_m_mt=Tbox_mm_m;
    Tbox_m_mt(1:3,4)=Tbox_mm_m(1:3,4)/1000;
    %convertion of Tbox_gt to meters
    Tbox_gt_mt=Tbox_gt;
    Tbox_gt_mt(1:3,4)=Tbox_gt(1:3,4)/1000;%convertion to meters

    d=norm(Tbox_m_mt(1:3,4)-Tbox_gt_mt(1:3,4))
figure,
    
    dibujarsistemaref(T0,'m',1,1,10,'black')%mocap
    hold on
    dibujarsistemaref(Tbox_m_mt,'b',1,1,10,'black')%estimated box in qm in mt
    dibujarsistemaref(Tbox_gt_mt,'b_{gt}',1,1,10,'black')%ground truth box
%     dibujarsistemaref(Th_mt,'h',1,1,10,'black')%hololens

    grid on 
    xlabel x
    ylabel y
    zlabel z
    title 'box pose transformed to qm. Estimated vs ground truth'

end