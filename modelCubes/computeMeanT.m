function Tmean = computeMeanT(localPlanes, keyPlaneTwins)
%COMPUTEMEANT Computes the mean value of rotation matrix and translation
%vector
%   Detailed explanation goes here

tacc=[];
r1acc=[];
r2acc=[];
r3acc=[];

Nt=size(keyPlaneTwins,1);

for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
    Tbox=currentTwin.tform;%distance in mt, angles in rad or degrees
    t=Tbox(1:3,4);
    r1=Tbox(1:3,1);
    r2=Tbox(1:3,2);
    r3=Tbox(1:3,3);

    tacc=[tacc t];
    r1acc=[r1acc r1];
    r2acc=[r2acc r2];
    r3acc=[r3acc r3];
end
tmean=mean(tacc,2);
r1mean=mean(r1acc,2);
r2mean=mean(r2acc,2);
r3mean=mean(r3acc,2);

Tmean=eye(4);
Tmean(1:3,4)=tmean;
Tmean(1:3,1:3)=[r1mean r2mean r3mean];

end

