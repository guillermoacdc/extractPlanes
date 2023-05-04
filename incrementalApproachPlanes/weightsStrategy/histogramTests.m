% requires to run computeRelationshipBtwnDistanceAndError.m
% D:\Users\Acer\Documents\planeExtractor\extractPlanes\incrementalApproachPlanes\computeRelationshipBtwnDistanceAndError.m
XX=[distanceAcc fitnessVector];
[~,idsort]=sort(distanceAcc);
XX=XX(idsort,:);

binSize=100;%mm
Ndata=size(distanceAcc,1);
Nbin=round((max(distanceAcc)-min(distanceAcc))/binSize);
myXaxis= linspace(min(distanceAcc), max(distanceAcc), Nbin);
myYaxis=hist(distanceAcc,Nbin);
figure,
bar(myXaxis,myYaxis)

figure,
histogram(distanceAcc,Nbin)
grid
xlabel ('distance camera plane (mm)')
ylabel ('Number of ocurrences')
title (['local Planes in session ID = ' num2str(sessionID)])


idx=find(eADD_dist>0.4);
X=distanceAcc;
X(idx,:)=[];
figure,
h=histogram(X,Nbin)
grid
xlabel ('distance camera plane (mm)')
ylabel ('Number of ocurrences in planes with e_{ADD} < 0.4')
title (['local Planes in session ID = ' num2str(sessionID)])



