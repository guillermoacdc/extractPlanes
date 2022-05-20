function assignationFlag = conditionedBySecondPlane(myPlanes, targetPlane, secondPlaneIndex, dtargetOfSecondPlane, th_angle)
%CONDITIONEDBYSECONDPLANE Summary of this function goes here
%   Detailed explanation goes here
assignationFlag=false;
searchSpace=[secondPlaneIndex; dtargetOfSecondPlane];
secondPlaneIndex_v2 = secondPlaneDetection_v4(targetPlane,searchSpace,myPlanes, th_angle );
condition= secondPlaneIndex==secondPlaneIndex_v2;
if condition(1) & condition(2)
    myPlanes.(['fr' num2str(dtargetOfSecondPlane(1))])(dtargetOfSecondPlane(2)).secondPlaneID=[];
    myPlanes.(['fr' num2str(dtargetOfSecondPlane(1))])(dtargetOfSecondPlane(2)).thirdPlaneID=[];
    myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
    assignationFlag=true;
end
end

