function listIDs = extractBoxIds(myBoxes)
%EXTRACTBOXIDS Summary of this function goes here
%   Detailed explanation goes here
N=size(myBoxes,2);
listIDs=[];
for i=1:N
    listIDs=[listIDs; myBoxes{i}.planesID];
end

end

