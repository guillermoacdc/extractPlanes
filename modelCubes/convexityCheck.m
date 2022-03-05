function [convexityFlag alfa1 alfa2] = convexityCheck(n1,gc1, n2, gc2)
%CONVEXITYCHECK Checks convexity btwn planes
%   It is based on Figure 4 from [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf


p12=gc1-gc2;
alfa1=computeAngleBtwnVectors(p12, n1);
alfa2=computeAngleBtwnVectors(p12, n2);
convexityFlag=false;
if alfa1<alfa2
    convexityFlag=true;
end
end

