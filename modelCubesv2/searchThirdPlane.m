function  searchThirdPlane(globalPlanes, couple, searchSpace, th_angle)
%SEARCHTHIRDPLANE Summary of this function goes here
%   Detailed explanation goes here
%  verify if there are repetitions in vector couple; where [x1 x2] is
%  duplicated with [x2 x1]. If so, avoid redundancy in the search. PS: x is
%  bidimensional

% create searchSpace tree
availableNormals=zeros(size(searchSpace,1),3);
for i=1:size(searchSpace,1)
%     frame_ss=searchSpace(i,1);
    element_ss=searchSpace(i);    
    availableNormals(i,:)=globalPlanes(element_ss).unitNormal;
end
searchSpace3P=KDTreeSearcher(availableNormals);
% perform the search

for i=1:size(couple,1)
    targetP=couple(i,1);
    secondP=couple(i,2);
    a=globalPlanes(targetP).unitNormal;
    b=globalPlanes(secondP).unitNormal;
    normalRef=cross(a,b);%create normal reference
    [thirdPlaneIndex, detectionFlag]=thirdPlaneDetection_v5(globalPlanes, ...
        targetP, secondP, searchSpace, normalRef, th_angle, searchSpace3P);
    if detectionFlag
        globalPlanes(targetP).thirdPlaneID=thirdPlaneIndex;
    end
end

end

