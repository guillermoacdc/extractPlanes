function [speed] = getSpeedSession(dataSetPath,sessionID)
%GETSPEEDSESSION Returns the categorized speed of a session
header=loadHeader(dataSetPath,sessionID);
speedC=header.Var1(6);

if speedC==1
    speed=1;
else
    speed=3;
end
end

