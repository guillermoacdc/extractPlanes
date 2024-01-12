function [globalPlanes, bufferCP] = performMergeSingleMap(globalPlanes,tao, theta, ...
    th_coplanarDistance, thresholdsV, planeModelParameters, ...
    lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferCP)
%PERFORMMERGESINGLEMAP Perform Merge btwn elements of a single map and a
%single frame
%   Detailed explanation goes here

% parameters to compute type of twin:
% tao, theta, flagPK, th_coplanarDistance
% parameters to merge point clouds:
%                 thresholdsV, planeModelParameters, lengthBoundsTop, gridStep, lengthBoundsP,...
%                 compensateFactor
Ng=length(globalPlanes);
i=1;
while i<=Ng
    j=i+1;
    while  j<=Ng
        if j>Ng
            disp(['stop with i/j = ' num2str(i) '/' num2str(j)])
        end
        planeA=globalPlanes(i);
        planeB=globalPlanes(j);
        
%         typeOfTwin=computeTypeOfTwin(planeA, planeB, tao, theta, flagPK, th_coplanarDistance);
%         typeOfTwin=computeTypeOfTwin_v2(planeA, planeB,...
%                 tao, theta, lengthBoundsTop, lengthBoundsP, th_coplanarDistance);

        typeOfTwin=computeTypeOfTwin_v3(planeA, planeB,...
                tao, theta, lengthBoundsTop, lengthBoundsP, th_coplanarDistance);
        if typeOfTwin==1
            if planeA.distanceToCamera<planeB.distanceToCamera & planeA.distanceToCamera<0.5
                globalPlanes(i)=planeA;
                globalPlanes(j)=[];
            else
                globalPlanes(i)=planeB;
                globalPlanes(j)=[];
            end
            Ng=Ng-1;
        elseif typeOfTwin==4
            [planeC, bufferCP]=combineCommonType4(planeA, planeB, bufferCP,...
                thresholdsV, planeModelParameters, lengthBoundsTop, gridStep, lengthBoundsP,...
                compensateFactor);
            globalPlanes(i)=planeC;
            globalPlanes(j)=[];
            Ng=Ng-1;
        end
        j=j+1;
    end
    i=i+1;
end
end

