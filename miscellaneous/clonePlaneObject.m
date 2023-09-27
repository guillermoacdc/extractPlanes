function [outputVector] = clonePlaneObject(inputVector)
%CLONEPLANEOBJECT Clones a handle object called plane
%   Detailed explanation goes here.
% outputVector=[];
N=size(inputVector,2);
if N>0
    for i=1:N
    %     copy properties required in the constructor
        c_scene=inputVector(i).idScene;
        c_frame=inputVector(i).idFrame;
        c_pID=inputVector(i).idPlane;
        c_modelParameters=[inputVector(i).unitNormal, inputVector(i).D...
            inputVector(i).geometricCenter];
        c_pathInliers=inputVector(i).pathPoints;
        c_NumbInliers=inputVector(i).numberInliers;
        outputVector(i)=plane(c_scene,c_frame,c_pID,c_modelParameters,c_pathInliers,c_NumbInliers);
    
        %     copy the rest of properties
        outputVector(i).limits=inputVector(i).limits;
        outputVector(i).type=inputVector(i).type;
        outputVector(i).L1=inputVector(i).L1;
        outputVector(i).L2=inputVector(i).L2;
        outputVector(i).tform=inputVector(i).tform;
        outputVector(i).DFlag=inputVector(i).DFlag;
        outputVector(i).lengthFlag=inputVector(i).lengthFlag;
        outputVector(i).antiparallelFlag=inputVector(i).antiparallelFlag;
        outputVector(i).topOccludedPlaneFlag=inputVector(i).topOccludedPlaneFlag;
        outputVector(i).L2toY=inputVector(i).L2toY;
        outputVector(i).planeTilt=inputVector(i).planeTilt;
        outputVector(i).secondPlaneID=inputVector(i).secondPlaneID;
        outputVector(i).thirdPlaneID=inputVector(i).thirdPlaneID;
        outputVector(i).nearestPlaneID=inputVector(i).nearestPlaneID;
        outputVector(i).secondNearestPlaneID=inputVector(i).secondNearestPlaneID;
        outputVector(i).x1=inputVector(i).x1;
        outputVector(i).x2=inputVector(i).x2;
        outputVector(i).y1=inputVector(i).y1;
        outputVector(i).y2=inputVector(i).y2;
        outputVector(i).distanceToCamera=inputVector(i).distanceToCamera;
    
        outputVector(i).composed_idFrame=inputVector(i).composed_idFrame;
        outputVector(i).composed_idPlane=inputVector(i).composed_idPlane;
        outputVector(i).angleBtwn_zc_unitNormal=inputVector(i).angleBtwn_zc_unitNormal;
        outputVector(i).fitness=inputVector(i).fitness;
        outputVector(i).timeParticleID=inputVector(i).timeParticleID;
        outputVector(i).D_qhmov=inputVector(i).D_qhmov;
    end    
else
    outputVector=[];
end


end

