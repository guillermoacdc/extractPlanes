function [cameraPoses] = myCameraPosesRead(cameraPosePath)
%MYCAMERAPOSESREAD Loads the poses of camera from a path, convert to mm and
%returns 
%   Assumptions: poses are loaded in meters
cameraPoses=importdata(cameraPosePath);
%***** convert to mm
cameraPoses(:,[5,9,13])=cameraPoses(:,[5,9,13])*1000;
end

