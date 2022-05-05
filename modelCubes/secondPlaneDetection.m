function [secondPlaneIndex] = secondPlaneDetection(targetPlane,searchSpace,planesDescriptor, th_angle )
%SECONPLANEDETECTION Summary of this function goes here
%   computes second plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 

candidates1=[];
candidates2=[];
k=1;
% searchSpace=setdiff(acceptedPlanes,targetPlane);
%% select candidates by perpendicularity criterion
normTarget=planesDescriptor{targetPlane}.unitNormal;
for(i=1:1:length(searchSpace))
    normCandidate=planesDescriptor{searchSpace(i)}.unitNormal;
    beta=computeAngleBtwnVectors(normTarget,normCandidate);
    if abs(cos(beta*pi/180))< cos (pi/2-th_angle)
%     if(planesDescriptor{targetPlane}.type ~= planesDescriptor{searchSpace(i)}.type)
        candidates1(k)=i;
        k=k+1;
    end
end

if (isempty(candidates1))
    secondPlaneIndex=-1;
    return
end
%% select candidates by convexity criterion
k=1;
for(i=1:1:length(candidates1))
    convFlag=convexityCheck(planesDescriptor{targetPlane}.unitNormal,...
        planesDescriptor{targetPlane}.geometricCenter,...
        planesDescriptor{searchSpace(candidates1(i))}.unitNormal,...
        planesDescriptor{searchSpace(candidates1(i))}.geometricCenter);

    if (convFlag)
        candidates2(k)=i;
        k=k+1;
    end
end

if (isempty(candidates2))
    secondPlaneIndex=-1;
    return
end

%% select candidates by distance criterion
v1=planesDescriptor{targetPlane}.geometricCenter;
for (i=1:1:length(candidates2))
    v2=planesDescriptor{searchSpace(candidates1(candidates2(i)))}.geometricCenter;
    dist_v(i)=norm(v1-v2);
end
[~,selectedIndex]=min(dist_v);
secondPlaneIndex=searchSpace(candidates1(candidates2(selectedIndex)));
end


