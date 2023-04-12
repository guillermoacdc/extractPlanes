function index = extractIndexFromIDs(planesVector,frameID,planeID)
%EXTRACTINDEXFROMIDS Summary of this function goes here
%   Detailed explanation goes here
IDsVector=extractIDsFromVector(planesVector);
index=myFind2D([frameID planeID],IDsVector);
end

