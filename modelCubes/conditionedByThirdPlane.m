function assignationFlag = conditionedByThirdPlane(myPlanes, targetPlane, secondPlaneIndex, dtargetOfThirdPlane, th_angle)
%CONDITIONEDBYTHIRDPLANE Summary of this function goes here
%   Detailed explanation goes here
assignationFlag=false;
dSecondId=myPlanes.(['fr' num2str(dtargetOfThirdPlane(1))])(dtargetOfThirdPlane(2)).secondPlaneID;
searchSpace=[secondPlaneIndex; dSecondId; dtargetOfThirdPlane];
secondPlaneIndex_v2 = secondPlaneDetection_v4(targetPlane,searchSpace,myPlanes, th_angle );
condition= secondPlaneIndex==secondPlaneIndex_v2;
if condition(1) & condition(2)
    myPlanes.(['fr' num2str(dtargetOfThirdPlane(1))])(dtargetOfThirdPlane(2)).thirdPlaneID=[];
    myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
    assignationFlag=true;
end
end



