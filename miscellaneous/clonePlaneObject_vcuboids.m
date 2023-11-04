function [outputVector] = clonePlaneObject_vcuboids(inputVector)
%CLONEPLANEOBJECT Clones a handle object called plane
%   Detailed explanation goes here.
% outputVector.values=[];
N=size(inputVector.values,2);
if N>0
    for i=1:N
    %     copy properties required in the constructor
        c_scene=inputVector.values(i).idScene;
        c_frame=inputVector.values(i).idFrame;
        c_pID=inputVector.values(i).idPlane;
        c_modelParameters=[inputVector.values(i).unitNormal, inputVector.values(i).D...
            inputVector.values(i).geometricCenter];
        c_pathInliers=inputVector.values(i).pathPoints;
        c_NumbInliers=inputVector.values(i).numberInliers;
        outputVector.values(i)=plane(c_scene,c_frame,c_pID,c_modelParameters,c_pathInliers,c_NumbInliers);
    
        %     copy the rest of properties
        outputVector.values(i).limits=inputVector.values(i).limits;
        outputVector.values(i).type=inputVector.values(i).type;
        outputVector.values(i).L1=inputVector.values(i).L1;
        outputVector.values(i).L2=inputVector.values(i).L2;
        outputVector.values(i).tform=inputVector.values(i).tform;
        outputVector.values(i).DFlag=inputVector.values(i).DFlag;
        outputVector.values(i).lengthFlag=inputVector.values(i).lengthFlag;
        outputVector.values(i).antiparallelFlag=inputVector.values(i).antiparallelFlag;
        outputVector.values(i).topOccludedPlaneFlag=inputVector.values(i).topOccludedPlaneFlag;
        outputVector.values(i).L2toY=inputVector.values(i).L2toY;
        outputVector.values(i).planeTilt=inputVector.values(i).planeTilt;
        outputVector.values(i).secondPlaneID=inputVector.values(i).secondPlaneID;
        outputVector.values(i).thirdPlaneID=inputVector.values(i).thirdPlaneID;
        outputVector.values(i).nearestPlaneID=inputVector.values(i).nearestPlaneID;
        outputVector.values(i).secondNearestPlaneID=inputVector.values(i).secondNearestPlaneID;
        outputVector.values(i).x1=inputVector.values(i).x1;
        outputVector.values(i).x2=inputVector.values(i).x2;
        outputVector.values(i).y1=inputVector.values(i).y1;
        outputVector.values(i).y2=inputVector.values(i).y2;
        outputVector.values(i).distanceToCamera=inputVector.values(i).distanceToCamera;
    
        outputVector.values(i).composed_idFrame=inputVector.values(i).composed_idFrame;
        outputVector.values(i).composed_idPlane=inputVector.values(i).composed_idPlane;
        outputVector.values(i).angleBtwn_zc_unitNormal=inputVector.values(i).angleBtwn_zc_unitNormal;
        outputVector.values(i).fitness=inputVector.values(i).fitness;
        outputVector.values(i).timeParticleID=inputVector.values(i).timeParticleID;
        outputVector.values(i).D_qhmov=inputVector.values(i).D_qhmov;
        outputVector.xzIndex=inputVector.xzIndex;
        outputVector.xyIndex=inputVector.xyIndex;
        outputVector.zyIndex=inputVector.zyIndex;
    end    
else
    outputVector.values=[];
    outputVector.xzIndex=[];
    outputVector.xyIndex=[];
    outputVector.zyIndex=[];
end


end

