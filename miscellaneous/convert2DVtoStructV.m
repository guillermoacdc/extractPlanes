function [myStruct] = convert2DVtoStructV(visiblePlanes)
%convert2DVtoStructV Summary of this function goes here
%   Detailed explanation goes here
if isempty(visiblePlanes)
    myStruct.planesID=[];
    myStruct.boxID=[];
else
    boxIDs=unique(visiblePlanes(:,1));
    Nb=length(boxIDs);
    for i=1:Nb
        tstruct.boxID=boxIDs(i);
        myrows=find(visiblePlanes(:,1)==tstruct.boxID);
        tstruct.planesID=visiblePlanes(myrows,2);
        myStruct(i)=tstruct;
    end
end

end

