clc
close all
clear
% PARAMETERS
boxID=9;
originFlag=false;
sessionID=3;
frameIDMoCap=10;
dataSetpath=computeMainPaths(sessionID);
% load localization of points p1, p2
[p1, p2]=loadMarkerPosition(sessionID,frameIDMoCap, boxID);
% load lengths
lengths=loadLengths(dataSetpath,sessionID);
index=find(lengths(:,1)==boxID);
H=lengths(index,4);
L2=lengths(index,3);
L1=lengths(index,2);
% ground normal with slope
A=0.0048;
B=0.0261;
C=0.9996;

% compute ground truth pose
tform2=computeTformBox(p1,p2,A,B,C,L2,H, originFlag);

NpointsDiagTopSide=25;
numberOfSides=3;
% compute synthetic pc from current tform in dataset

temp_planeDescriptor=convertPK2PlaneObjects_v4(dataSetpath,sessionID,1,2,boxID);
cplaneDescriptor.fr0.values(1)=temp_planeDescriptor;
cpcBox=createSyntheticPC(cplaneDescriptor,NpointsDiagTopSide, numberOfSides);
cpcBox_m=myProjection_v3(cpcBox{1},cplaneDescriptor.fr0.values(1).tform);

% compute synthetic pc from new tform
planeDescriptor.fr0.values(1).L1=L1;
planeDescriptor.fr0.values(1).L2=L2;
planeDescriptor.fr0.values(1).D=H;
planeDescriptor.fr0.values(1).tform=tform2;
pcBox=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
pcBox_m=myProjection_v3(pcBox{1},planeDescriptor.fr0.values(1).tform);


% correct rotation
[~, er]=computeSinglePoseError(temp_planeDescriptor.tform,tform2);%as stated in Hodane 2016 we compute Reference-Estimated
if (abs(er)>150)
%     apply rotz(180) in tform2
    R=tform2(1:3,1:3);
    R=rotz(180)*R;
    tform2(1:3,1:3)=R;
end

% figure,
%     pcshow(cpcBox_m)
%     hold
%     dibujarsistemaref(eye(4),'m',150,2,10,'y')
%     plot3(p1(1),p1(2),p1(3),'yo');
%     hold on
%     plot3(p2(1),p2(2),p2(3),'yo');
%     xlabel 'x'
%     ylabel 'y'
%     zlabel 'z'
%     title 'synthetic pc from current initial pose'
% 
%  figure,
%     pcshow(pcBox_m)
%     hold
%     dibujarsistemaref(eye(4),'m',150,2,10,'y')
%     plot3(p1(1),p1(2),p1(3),'yo');
%     hold on
%     plot3(p2(1),p2(2),p2(3),'yo');
%     xlabel 'x'
%     ylabel 'y'
%     zlabel 'z'
%     title 'synthetic pc from modified initial pose'


 figure,
    pcshow(pcBox_m)
    hold
    pcshow(cpcBox_m)
%     dibujarsistemaref(eye(4),'m',150,2,10,'y')
    plot3(p1(1),p1(2),p1(3),'yo');
    hold on
    plot3(p2(1),p2(2),p2(3),'yo');
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'comparison synthetic pc '    


figure,
    plot3(p1(1),p1(2),p1(3),'bo');
    hold on
    plot3(p2(1),p2(2),p2(3),'bo');
    dibujarsistemaref(temp_planeDescriptor.tform,'b',150,2,10,'b')
    dibujarsistemaref(tform2,'new',150,2,10,'r')
    grid
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Adjust gt in sessión ' num2str(sessionID) ' boxID:' num2str(boxID)])
% Calculo de la distancia entre origen de la pose y el plano tierra a lo
% largo de la normal
d1=[A B C]*planeDescriptor.fr0.values(1).tform(1:3,4);
dc=[A B C]*cplaneDescriptor.fr0.values(1).tform(1:3,4);


% temporal planedescriptor
tempPdesc.idBox=boxID;
tempPdesc.tform=tform2;
updateP=unassemblyTMatrix(tempPdesc);
updateP=[updateP(1) frameIDMoCap, updateP(2:end)];
P_table=table(updateP);
writetable(P_table,'updatedP.csv','WriteMode','Append',...
    'WriteVariableNames',false)
