function [thirdPlanes] = retrieveThirdPlanes(myPlanes)
%RETRIEVESECONDPLANES Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames( myPlanes );
N1=size(fields,1);
thirdPlanes=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        if ~isempty(myPlanes.(fields{i})(j).thirdPlaneID) 
            thirdPlanes=[thirdPlanes; myPlanes.(fields{i})(j).getID];
        end
    end
end

end




