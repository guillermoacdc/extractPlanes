function [globalPlanes, bufferCP]=performMerge_v2(localPlane,globalPlanes,...
    idx, typeOfTwin, bufferCP, tresholdsV, lengthBoundsTop, lengthBoundsP, planeModelParameters)
%PERFORMMERGE Perfoms merge operation between two planes: localPlane,
%globalPlanes(idx), based on the type of twin informed. The merged version 
% of the plane is saved in globalPlanes vector
% Inputs-------------
% 1. localPlane: descriptor of a local Plane
% 2. globalPlanes: vector with descriptors of globalPlanes
% 3. idx: index of the global plane
% 4. typeOfTwin: id of type of twin with four possible values
% 5. A_l: Area of local plane
% 6. A_g: Area of global plane
% 7. distance_c_l: distance betwen camera and geometric center of local plane.
% 8. distance_c_g: distance betwen camera and geometric center of global plane.
% Vector of size Nx1

% Type of twin description
% -------0 No twin
% -------1 non occluded planes
% -------2 planes with merged area
% -------3 partial occluded planes
% -------4 sub-segment of planes of a common segment of plane

% Outputs-------------
% 1. globalPlanes. Output with pass by reference. 
% Assumptions-------------
% 1. the input planes belong to the same type
% 2. 

sessionID=localPlane.idScene;
th_lenght=tresholdsV(1);
th_size=tresholdsV(2);
th_occlusion=tresholdsV(4);
maxDistance=planeModelParameters(1);
maxAngularDistance=planeModelParameters(2);
referenceVector=planeModelParameters(3:end);

distance_c_l=localPlane.distanceToCamera;
distance_c_g=globalPlanes(idx).distanceToCamera;

A_l=localPlane.L1*localPlane.L2;
A_g=globalPlanes(idx).L1*globalPlanes(idx).L2;

switch (typeOfTwin)
    case 1
        if (distance_c_l<distance_c_g & distance_c_l>0.5)
            globalPlanes(idx)=localPlane;
        end
    case 2

        if A_l<A_g
            globalPlanes(idx)=localPlane;%replace the previous Plane with the new local Plane
        end
    case 3
        if A_l>A_g
            globalPlanes(idx)=localPlane;%replace the previous Plane with the new local Plane
        end        
    case 4
        
% create the new point cloud
        pcA=myPCreadComposedPlane(globalPlanes(idx).pathPoints, ...
            globalPlanes(idx).idFrame, globalPlanes(idx).idPlane, bufferCP);
        pcB=myPCreadComposedPlane(localPlane.pathPoints, ...
            localPlane.idFrame, localPlane.idPlane, bufferCP);
        pcnew=pcmerge(pcA,pcB,0.1);%mm        
%%  Add components to bufferCP vector
%         Ncomp=size(buffer,2);%calcule el máximo valor en globalPlanes.composed_idPlane
        Ncomp=computeMaxNcomposedIDPlane(bufferCP);%calcule el máximo valor en globalPlanes.composed_idPlane
%         globalPlanes(idx).composed_idFrame=0;
%         globalPlanes(idx).composed_idPlane=Ncomp+1;
%         localPlane.composed_idFrame=0;
%         localPlane.composed_idPlane=Ncomp+1;
%         bufferCP=[bufferCP globalPlanes(idx) localPlane];
        bufferCP = updateBufferCP(globalPlanes(idx),localPlane, bufferCP, Ncomp);
        

%%   Create composed plane, compute new parameters and write them to globalPlanes
        % Set paramaters to compute the plane model from the new pointcloud
%         maxDistance=0.1*1000;%mm
%         maxAngularDistance=5;%deg
%         referenceVector=[0 1 0];
        model = pcfitplane(pcnew,maxDistance,referenceVector,maxAngularDistance);

        newParameters=[model.Parameters 0, 0, 0]; %is assumed that the geometric center will be recomputed
 
    %   create a new composed plane, with double value in its IDs

%         condicionar almacenamieto de pathPoints. En caso de que planeX
%         sea compuesto, recuperar los componentes y armar un cell único.
%         Esto para que la función soft de carga de PCs opere  
        newPath = computePathMergedPlane(globalPlanes(idx).pathPoints,localPlane.pathPoints);
        composedPlane=plane(sessionID,0,...
                Ncomp+1,newParameters,...
                newPath,pcnew.Count);
        
        % classify the plane object
            % inherit basic properties
                composedPlane.type=localPlane.type;
                if composedPlane.type==1
                    composedPlane.L2toY=localPlane.L2toY;
                    composedPlane.planeTilt=localPlane.planeTilt;
                end
            
                % set limits and update geometric center. The update is necessary to include the projection of points to
                %     the plane model before compute g.c. 
                composedPlane.setLimits(pcnew);%set limits in each axis.
                %     detect antiparallel normals and correct
                composedPlane.correctAntiparallel(th_size);%
                % measure pose and length, and updata occlusion flag
                composedPlane.measurePoseAndLength(pcnew, th_occlusion, 0);
                % set length flag based on type of plane
                if composedPlane.type==0
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsTop,th_lenght);
                else
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsP,th_lenght);
                end
                composedPlane.setLengthFlag(lengthFlag);
            
%%   Delete components from its previous container
        globalPlanes(idx)=[];
        localPlane=[];%verify pass by reference
%%   insert composedPlane into globalPlanes
        globalPlanes=[globalPlanes composedPlane];        
end

end

