function [modelParameters] = loadAlgorithmParameters(planesPath,frame)
%LOADALGORITHMPARAMETERS Returns the parameters of a plane model for ground
%   Detailed explanation goes here
modelParameters=0;
% A=load([planesPath + "algorithmParameters.txt"]);
A=importdata([planesPath + "algorithmParameters.txt"]);
modelParameters_str=A{4};
modelParameters=sscanf(modelParameters_str(35:end-1),'%f,');%this line depends on the format of the file algorithmParameters.txt 
end

