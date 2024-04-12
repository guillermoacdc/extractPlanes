function triadIndex = computeTriadIndex(globalPlanes,index)
%COMPUTETRIADINDEX Returns the indexes that conform a triad that belong to
%a single box
%   Detailed explanation goes here
    firstPlaneID=index;
    planeWithTriad=globalPlanes.values(firstPlaneID);
    secondPlaneID=planeWithTriad.secondPlaneID;
    thirdPlaneID=planeWithTriad.thirdPlaneID;
    triadIndex=[firstPlaneID, secondPlaneID, thirdPlaneID];
end

