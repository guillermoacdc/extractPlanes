function outputCell = convertIDsToCell(IDs)
%CONVERTIDSTOCELL Summary of this function goes here
%   Detailed explanation goes here
N=size(IDs,1);
outputCell={};

for i=1:N
    outputCell{i}= [num2str(IDs(i,1)) '-' num2str(IDs(i,2))]
end

end

