function Tnew = updateSessionDescriptor(sessionID,dataSetPath,factorsForSession)
%UPDATESESSIONDESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here
T=loadSessionDescriptor(dataSetPath,sessionID);
Tnew=T;
Tnew.factorLevels=factorsForSession;


end

