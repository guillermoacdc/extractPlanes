clc
close all
clear
%% PARAMETERS
boxID=15;
originFlag=true;
sessionID=3;
frameIDMoCap=10;
dataSetpath=computeMainPaths(sessionID);
% ground normal with slope
A=0.0048;
B=0.0261;
C=0.9996;
% load localization of points p1, p2
[p1, p2]=loadMarkerPosition(sessionID,frameIDMoCap, boxID);
% load lengths
lengths=loadLengths(dataSetpath,sessionID);
index=find(lengths(:,1)==boxID);
H=lengths(index,4);
L2=lengths(index,3);
L1=lengths(index,2);


%% compute ground truth pose
tform2=computeTformBox(p1,p2,A,B,C,L2,H, originFlag);

%% compute current gt pose
temp_planeDescriptor=convertPK2PlaneObjects_v4(dataSetpath,sessionID,1,2,boxID);
tform_current=temp_planeDescriptor.tform;


% correct rotation
[et, er]=computeSinglePoseError(tform_current,tform2);%as stated in Hodane 2016 we compute Reference-Estimated
if abs(et)>0.9*L2/2
    originFlag=false;
    tform2=computeTformBox(p1,p2,A,B,C,L2,H, originFlag);
end

if (abs(er)>150)
%     apply rotz(180) in tform2
    R=tform2(1:3,1:3);
    R=rotz(180)*R;
    tform2(1:3,1:3)=R;
end


  


figure,
    plot3(p1(1),p1(2),p1(3),'bo');
    hold on
    plot3(p2(1),p2(2),p2(3),'bo');
    dibujarsistemaref(tform_current,'b',150,2,10,'b')
    dibujarsistemaref(tform2,'new',150,2,10,'r')
    grid
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Adjust gt in sessión ' num2str(sessionID) ' boxID:' num2str(boxID)])
% Calculo de la distancia entre origen de la pose y el plano tierra a lo
% largo de la normal
dc=[A B C]*tform_current(1:3,4);
d2=[A B C]*tform2(1:3,4);

% temporal planedescriptor
tempPdesc.idBox=boxID;
tempPdesc.tform=tform2;
updateP=unassemblyTMatrix(tempPdesc);
updateP=[updateP(1) frameIDMoCap, updateP(2:end)];
P_table=table(updateP);
writetable(P_table,'updatedP.csv','WriteMode','Append',...
    'WriteVariableNames',false)
