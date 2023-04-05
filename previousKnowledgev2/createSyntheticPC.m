function pcBox=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides)
%CREATESYNTHETICPC Creates a cell of point clouds with Nboxes elements, where
%Nboxes is the number of boxes in planeDescriptor
% Assumption: planeDescriptor just have information of top planes
%   Detailed explanation goes here
% Nboxes=length(planeDescriptor.fr0.values);
Nboxes=size(planeDescriptor.fr0.values,1);
for i=1:Nboxes
    % load height
    H=planeDescriptor.fr0.values(i).D;
    % load depth and width for each box in scene
    L1=planeDescriptor.fr0.values(i).L1;
    L2=planeDescriptor.fr0.values(i).L2;
    spatialSampling=sqrt(L1^2+L2^2)/NpointsDiagTopSide;
    pcTopPlane{i}=createSingleBoxPC_topSide(L1,L2,H,spatialSampling);
%     create the objects
    switch numberOfSides
        case 1
            %         create box with a single side (top side)
            pcBox{i}=createSingleBoxPC_topSide(L1,L2,H,spatialSampling);
            
        case 2
            %         create box with two sides. 
            pcBox{i}=createSingleBoxPC_twoSides(L1,L2,H,spatialSampling);
%             pcBox{i}=createSingleBoxPC_twoSides(L1,L2,H,spatialSampling);
        case 3
%             compute box with three sides. The opposite sides to point of
%             view are not included
            % compute angle btwn axis x (xm,xb)
            T=planeDescriptor.fr0.values(i).tform;
            angle=computeAngleBtwnVectors([1 0 0]',T(1:3,1));
            if(T(2,1)<0)
                angle=-angle;
            end
    %         create box with three sides
            pcBox{i}=createSingleBoxPC_threeSides(L1,L2,H,spatialSampling, angle);
        otherwise
            disp('non defined value for number of sides')
    end
end



end

