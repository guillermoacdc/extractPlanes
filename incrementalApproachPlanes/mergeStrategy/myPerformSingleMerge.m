function [vectorPlanes] = myPerformSingleMerge(vectorPlanes,indexA, indexB)
%MYPERFORMSINGLEMERGE Summary of this function goes here
%   Detailed explanation goes here

newValue=vectorPlanes(indexA);
vectorPlanes(indexB)=[];
vectorPlanes(indexA)=[];

vectorPlanes=[vectorPlanes newValue];
end

