function [vectorPlanes, bufferCP]=performSingleMerge_v2(vectorPlanes,indexA,...
    indexB, bufferCP, tresholdsV, planeModelParameters, lengthBoundsTop, lengthBoundsP, gridStep)
%PERFORMSINGLEMERGE performs a merge between planes that belong to the same
%frame. 
% _v2 uses the function planeMerge to compute the composedPlane
%   Detailed explanation goes here
sessionID=vectorPlanes(1).idScene;
th_lenght=tresholdsV(1);
th_size=tresholdsV(2);
th_occlusion=tresholdsV(4);
maxDistance=planeModelParameters(1);
% maxAngularDistance=planeModelParameters(2);
% referenceVector=planeModelParameters(3:end);

planeA=vectorPlanes(indexA);
planeB=vectorPlanes(indexB);
%%   add components to the bufferCP vector
Ncomp=computeMaxNcomposedIDPlane(bufferCP);
bufferCP = updateBufferCP(planeA,planeB, bufferCP, Ncomp);

composedPlane = planeMerge(planeA,planeB, gridStep,...
    bufferCP, maxDistance, th_size, th_occlusion, lengthBoundsTop,...
    lengthBoundsP, th_lenght);          
%%   delete id of components from vectorPlanes
        vectorPlanes(indexB)=[];
        vectorPlanes(indexA)=[];

%%   insert composedPlane into vectorPlanes
        vectorPlanes=[vectorPlanes composedPlane];

end

