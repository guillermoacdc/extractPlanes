function [globalPlanes, localPlanes]=myPerformMerge(globalPlanes,i,localPlanes,j)
%MYPERFORMMERGE Summary of this function goes here
%   Detailed explanation goes here

globalPlanes(i)=[];
globalPlanes=[globalPlanes localPlanes(j)];
localPlanes(j)=[];

end

