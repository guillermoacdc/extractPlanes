% script
%CREATEBOXOBJECT_VCUBOIDS_TEST Summary of this function goes here
%   Detailed explanation goes here


% select a triadID
% Np=length(group_tpp);
Ng=length(group_tpp);
for i_box=1:Ng
    splane=globalPlanes.values(group_tpp(i_box));
    secondIndex=splane.secondPlaneID;
    thirdIndex=splane.thirdPlaneID;
    triadID=[splane.getID(), globalPlanes.values(secondIndex).getID, globalPlanes.values(thirdIndex).getID];
    disp(['          splane ' num2str(triadID(1)) '-' num2str(triadID(2))...
        ' is associated with splane ' num2str(triadID(3)) '-' num2str(triadID(4)),...
        ' and splane ' num2str(triadID(5)) '-' num2str(triadID(6))])
    boxID=i_box;
    triadIndex=[group_tpp(i_box), secondIndex thirdIndex];
    globalBoxes(i_box)=createBoxObject_vcuboids(globalPlanes.values,triadIndex,boxID); 
end


% figure,
% %     mypcshow(globalPlanes(group_tpp(3)),dataSetPath,sessionID);
%     pcshow(pc1)
%     hold on
%     pcshow(pc2)
%     pcshow(pc3)
%     myPlotPlaneContour(globalPlanes(group_tpp(1)),'w');
%     myPlotPlaneContourPerpend(globalPlanes(group_tpp(2)),'w');
%     myPlotPlaneContourPerpend(globalPlanes(group_tpp(3)),'w');
%     plot3(p0(1),p0(2),p0(3),'yo')
%     xlabel 'x'
%     ylabel 'y'
%     zlabel 'z'
% figure,
%     myPlotPlanes_v3(globalPlanes(group_tpp),1)
%     plot3(p0(1),p0(2),p0(3),'yo')
%     xlabel 'x'
%     ylabel 'y'
%     zlabel 'z'