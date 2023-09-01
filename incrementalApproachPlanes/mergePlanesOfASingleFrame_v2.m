function [vectorPlanes,bufferCP]=mergePlanesOfASingleFrame_v2(vectorPlanes,bufferCP, tresholdsV,...
    lengthBoundsTop, lengthBoundsP, planeModelParameters, gridStep)
%MERGEPLANESOFASINGLEFRAME Performs the merge of pair of planes with type 4.
%This type exists when two point clouds must be merge. The new point cloud
%is used to compute plane parameters, then is destructed. The relationship
%between merged planes and its componets is saved in the vectorPlanes
%descriptors. The vector bufferCP saves descriptors of the components. 

% vectorPlanes: vector with planes objects of a single frame; can be
% local or global
% bufferCP: vector of component planes
% planeModelParameters: vector with thresholds to extract plane models
% tresholdV: vector with thresholds to filter extracted planes
% lengthBoundsX: previous knowledge of max size in Top and Perpendicular
% planes

if nargin<7
    gridStep=1;
end

N=size(vectorPlanes,2);
if N==1
    myCounter=0;
else
    nonRPairs=nchoosek(1:N,2);
    myCounter=size(nonRPairs,1);
end

i=1;
while myCounter>=1
    indexA=nonRPairs(i,1);
    indexB=nonRPairs(i,2);
    planeA=vectorPlanes(indexA);
    planeB=vectorPlanes(indexB);
%     load parameter based on plane.type
    maxTopSize=(sqrt(lengthBoundsTop(1)^2+lengthBoundsTop(2)^2)*(planeA.type==0))+...
        (sqrt(lengthBoundsP(1)^2+lengthBoundsP(2)^2)*(planeA.type~=0));
    
%     type4= (planeA==planeB);
    type4=isType4(planeA,planeB, maxTopSize,planeModelParameters(1));

    if type4
%         [vectorPlanes, bufferCP]=performSingleMerge_v2(vectorPlanes,indexA,...
%             indexB, bufferCP, tresholdsV, planeModelParameters, lengthBoundsTop,...
%             lengthBoundsP, gridStep);
        [vectorPlanes, bufferCP]=performSingleMerge(vectorPlanes,indexA,...
            indexB, bufferCP, tresholdsV, planeModelParameters, lengthBoundsTop, lengthBoundsP);
        N=size(vectorPlanes,2);
        if N>1
	        nonRPairs=nchoosek(1:N,2);
	        myCounter=size(nonRPairs,1);
	        i=1;
        else
            disp('vector with a single value')
            myCounter=0;
        end
%         nonRPairs=nchoosek(1:N,2);
%         myCounter=size(nonRPairs,1);
%         i=1;
    else
        myCounter=myCounter-1;
        i=i+1;
    end

end
end


