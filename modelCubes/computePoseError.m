function [et, er, eL1, eL2]=computePoseError(localPlanes, keyPlaneTwins,...
    T, tform_gt, L1_gt, L2_gt)

t1=tform_gt(1:3,4)*100;%in cm
R1=tform_gt(1:3,1:3)*100;%without dimensions?
et=[];
er=[];
eL1=[];
eL2=[];

Nt=size(keyPlaneTwins,1);

for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
    Tm=T*currentTwin.tform;%transformation to qm
    t2=Tm(1:3,4);
    et=[et norm(t1-t2)];
    R2=Tm(1:3,1:3);
    aux=acos((trace(R1'*R2)-1)/2);
    er=[er aux];
    eL1=[eL1 abs(L1_gt-currentTwin.L1*100)];
    eL2=[eL2 abs(L2_gt-currentTwin.L2*100)];
end

end