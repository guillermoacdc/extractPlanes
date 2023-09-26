function [myStruct] = convert2DVtoStructV(visiblePlanes)
%convert2DVtoStructV Summary of this function goes here
%   Detailed explanation goes here
boxIDs=unique(visiblePlanes(:,1));
Nb=length(boxIDs);
for i=1:Nb
    tstruct.boxID=boxIDs(i);
    myrows=find(visiblePlanes(:,1)==tstruct.boxID);
    tstruct.planesID=visiblePlanes(myrows,2);
    myStruct(i)=tstruct;
end
end

