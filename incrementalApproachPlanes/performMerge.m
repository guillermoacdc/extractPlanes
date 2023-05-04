function globalPlanes=performMerge(localPlane,globalPlanes, idx, typeOfTwin)
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


% Outputs-------------
% 1. globalPlanes. Output with pass by reference. 
% Assumptions-------------
% 1. the input planes belong to the same type
% 2. 


% distance_c_l=localPlane.distanceToCamera;
% distance_c_g=globalPlanes(idx).distanceToCamera;

A_l=localPlane.L1*localPlane.L2;
A_g=globalPlanes(idx).L1*globalPlanes(idx).L2;

switch (typeOfTwin)
    case 1
        if localPlane.fitness>globalPlanes(idx).fitness
            globalPlanes(idx)=localPlane;
%             modificate gemetric Center of globalPlane
        [wg,wl]=computeWeigths(globalPlanes(idx).fitness,localPlane.fitness);
            globalPlanes(idx).geometricCenter=wg*globalPlanes(idx).geometricCenter+...
                wl*localPlane.geometricCenter;
        end

    case 2

        if A_l<A_g
            globalPlanes(idx)=localPlane;%replace the previous Plane with the new local Plane
        end
    case 3
        if A_l>A_g
            globalPlanes(idx)=localPlane;%replace the previous Plane with the new local Plane
        end        

end

end

