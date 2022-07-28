function  searchThirdPlane(myPlanes, couple, searchSpace, th_angle)
%SEARCHTHIRDPLANE Summary of this function goes here
%   Detailed explanation goes here
%  verify if there are repetitions in vector couple; where [x1 x2] is
%  duplicated with [x2 x1]. If so, avoid redundancy in the search. PS: x is
%  bidimensional

% create searchSpace tree
availableNormals=zeros(size(searchSpace,1),3);
for i=1:size(searchSpace,1)
    frame_ss=searchSpace(i,1);
    element_ss=searchSpace(i,2);    
    availableNormals(i,:)=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).unitNormal;
end
searchSpace3P=KDTreeSearcher(availableNormals);
% perform the search

for i=1:size(couple,1)
    targetP=couple(i,1:2);
    secondP=couple(i,3:4);
    a=myPlanes.(['fr' num2str(targetP(1))]).values(targetP(2)).unitNormal;
    b=myPlanes.(['fr' num2str(secondP(1))]).values(secondP(2)).unitNormal;
    normalRef=cross(a,b);%create normal reference
    [thirdPlaneIndex, detectionFlag]=thirdPlaneDetection_v5(myPlanes, ...
        targetP, secondP, searchSpace, normalRef, th_angle, searchSpace3P);
    if detectionFlag
        myPlanes.(['fr' num2str(targetP(1))]).values(targetP(2)).thirdPlaneID=thirdPlaneIndex;
    end
end

end

