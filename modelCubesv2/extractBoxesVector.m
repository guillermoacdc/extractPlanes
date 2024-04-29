function outputVector = extractBoxesVector(inputVector,boxIDvector)
%EXTRACTBOXESVECTOR extracts a subvector from inputVector, based on a field
%called boxID
%   Detailed explanation goes here
N=length(boxIDvector);
% initiate output
for k=1:N
    outputVector(k)=detectedBox(0,0,0,0,eye(4),0,0);
end

for i=1:N
    boxID=boxIDvector(i);
    boxObject=extractBoxByBoxID(inputVector,boxID);
    outputVector(i)=boxObject;
end
end

