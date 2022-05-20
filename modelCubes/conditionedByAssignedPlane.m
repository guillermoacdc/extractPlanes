function assignationFlag = conditionedByAssignedPlane(myPlanes, targetPlane, secondPlaneIndex, th_angle)
%CONDITIONEDBYASSIGNEDPLANE Summary of this function goes here
%   Detailed explanation goes here
assignationFlag=false;
frameA=secondPlaneIndex(1);
elementA=secondPlaneIndex(2);

Asecond=myPlanes.(['fr' num2str(frameA)])(elementA).secondPlaneID;
Athird=myPlanes.(['fr' num2str(frameA)])(elementA).thirdPlaneID;

searchSpace=[secondPlaneIndex; Asecond; Athird];
secondPlaneIndex_v2 = secondPlaneDetection_v4(targetPlane,searchSpace,myPlanes, th_angle );

condition= secondPlaneIndex==secondPlaneIndex_v2;
if condition(1) & condition(2)
    myPlanes.(['fr' num2str(frameA)])(elementA).secondPlaneID=[];
    myPlanes.(['fr' num2str(frameA)])(elementA).thirdPlaneID=[];
    myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
    assignationFlag=true;
end

end

