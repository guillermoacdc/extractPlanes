function outputVector = loadPlanesFromIDs_d(myPlanes,id)
%LOADPLANESFROMIDS Load a set of plane descriptors in a vector
%   ---input
% myPlanes: struct with plane descriptors
% id: identifiers of planes, with two digits per plane: (1) frame, (2)
% number of plane
% output
% outputVector. vector with loaded descriptors of planes. Size expected 1,N


N=size(id,1);%rows
if isempty(id)
    outputVector=[];
else
    for i=1:N
        outputVector(i)=myPlanes.(['fr' num2str(id(i,1))]).values(id(i,2));
    end
end



end

