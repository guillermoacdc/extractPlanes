function [globalPlanes, localPlanes, bufferCP]=performMerge_v4(localPlanes, id_lp, globalPlanes,...
    id_gp, typeOfTwin, bufferCP, tresholdsV, lengthBoundsTop, lengthBoundsP, planeModelParameters, gridStep)
%PERFORMMERGE Perfoms merge operation between two planes: localPlane,
%globalPlanes(id_gp), based on the type of twin informed. The merged version 
% of the plane is saved in globalPlanes vector
% Inputs-------------
% 1. localPlane: descriptor of a local Plane
% 2. globalPlanes: vector with descriptors of globalPlanes
% 3. id_gp: index of the global plane
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
localPlane=localPlanes(id_lp);
sessionID=localPlane.idScene;
th_lenght=tresholdsV(1);
th_size=tresholdsV(2);
th_occlusion=tresholdsV(4);
maxDistance=planeModelParameters(1);
% maxAngularDistance=planeModelParameters(2);
% referenceVector=planeModelParameters(3:end);

distance_c_l=localPlane.distanceToCamera;
distance_c_g=globalPlanes(id_gp).distanceToCamera;

A_l=localPlane.L1*localPlane.L2;
A_g=globalPlanes(id_gp).L1*globalPlanes(id_gp).L2;

switch (typeOfTwin)
    case 1
        if (distance_c_l<distance_c_g & distance_c_l>0.5)
            globalPlanes(id_gp)=localPlane;
        end
    case 2

        if A_l<A_g
            globalPlanes(id_gp)=localPlane;%replace the previous Plane with the new local Plane
        end
    case 3
        if A_l>A_g
            globalPlanes(id_gp)=localPlane;%replace the previous Plane with the new local Plane
        end        
    case 4
        
%%  Add components to bufferCP vector
        Ncomp=computeMaxNcomposedIDPlane(bufferCP);%calcule el máximo valor en globalPlanes.composed_idPlane
        bufferCP = updateBufferCP(globalPlanes(id_gp),localPlane, bufferCP, Ncomp);
        composedPlane = planeMerge(globalPlanes(id_gp),localPlane, gridStep,...
        bufferCP, maxDistance, th_size, th_occlusion, lengthBoundsTop,...
        lengthBoundsP, th_lenght);
%%   Delete components from its previous container
        globalPlanes(id_gp)=[];
        localPlanes(id_lp)=[];%verify pass by reference
%%   insert composedPlane into globalPlanes
        globalPlanes=[globalPlanes composedPlane];        
end

end

