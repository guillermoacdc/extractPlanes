function cuboidDetection_naivy(myPlanes, th_angle, acceptedPlanes)
%CUBOIDDETECTION_NAIVY Summary of this function goes here
%   Detailed explanation goes here

%% second plane detection
for i=1:length(acceptedPlanes)
    targetPlane=acceptedPlanes(i);
    searchSpace=setdiff(acceptedPlanes,targetPlane);
    secondPlaneIndex=secondPlaneDetection(targetPlane,searchSpace,myPlanes, th_angle);
    if(secondPlaneIndex~=-1)
        myPlanes{acceptedPlanes(i)}.secondPlaneID=secondPlaneIndex;
    end
end


%% third plane detection - uses pass by reference
thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)
end

