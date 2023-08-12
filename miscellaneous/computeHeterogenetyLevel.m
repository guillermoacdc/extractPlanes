function heterogenityLevel = computeHeterogenetyLevel(sessionID,frameID)
%COMPUTEHETEROGENETYLEVEL Summary of this function goes here
%   Detailed explanation goes here
numberInstancesByType=computeTypeAndInstances(sessionID,frameID);
typesVector=find(numberInstancesByType);%returns a vector containing the linear indices of each nonzero element in array
numberTypes=length(typesVector);
maxInstances=max(numberInstancesByType);
% normalize numberTypes. Expected range (1 - 9)
if numberTypes>9
    numberTypes_norm=1;
elseif numberTypes<1
    numberTypes_norm=0;
else
    numberTypes_norm=numberTypes/9;
end
% normalize maxInstances. Expected range (1 -4) 
if maxInstances>4
    maxInstances_norm=1;
elseif maxInstances<1
    maxInstances_norm=0;
else
    maxInstances_norm=(maxInstances-1)/3;
end
% compute level of heterogenity
% typesPerInstance=numberTypes_norm/maxInstances_norm;
heterogenityLevel=0.5*(1+numberTypes_norm-maxInstances_norm);

end

