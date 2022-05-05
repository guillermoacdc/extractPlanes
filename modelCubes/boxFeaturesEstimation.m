function [myBoxes]=boxFeaturesEstimation(myBoxes,assignedPlanes,myPlanes)
%BOXFEATURESESTIMATION Summary of this function goes here
%   Detailed explanation goes here
offset=size(myBoxes,2);
k=1;
for i=1:size(assignedPlanes,2)
    if myPlanes{assignedPlanes(i)}.type==0 %top planes
        secondID=myPlanes{assignedPlanes(i)}.secondPlaneID;
        thirdID=myPlanes{assignedPlanes(i)}.thirdPlaneID;
        [depth height width]=projectInEdgev2(myPlanes,assignedPlanes(i),...
            secondID,thirdID,1);

        myBoxes{k+offset}=detectedBox(k,depth, height, width);
        myPlanes{assignedPlanes(i)}.idBox=k;
        myPlanes{secondID}.idBox=k;
        myPlanes{thirdID}.idBox=k;
        k=k+1;
    end
end

end

