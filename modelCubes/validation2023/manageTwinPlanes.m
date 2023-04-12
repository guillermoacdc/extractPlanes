function   myPlanes=manageTwinPlanes(myPlanes,...
    ids_myPlanes, th_merge )
%MANAGETWINPLANES manages the finding and seeking of twin planes
%   Detailed explanation goes here
% th_merge=[th_gc, th_angle, th_IOU, th_dlower, th_dupper];

% myJoinedPlanes=myPlanes.fr0.values;
myJoinedPlanes.fr0=myPlanes.fr0;
if ~isempty(myJoinedPlanes.fr0)
    
    [c_xzPlanes, c_xyPlanes, c_zyPlanes]=extractTypes(myPlanes, ids_myPlanes);%planes from current frame

%     [j_xzPlanes, j_xyPlanes, j_zyPlanes]=extractTypes_vector(myJoinedPlanes);
    [j_xzPlanes, j_xyPlanes, j_zyPlanes]=extractTypes(myJoinedPlanes);

    myJoinedPlanes=findAndMergePlanes(j_xzPlanes, c_xzPlanes, myPlanes,myJoinedPlanes, th_merge);
    myJoinedPlanes=findAndMergePlanes(j_xyPlanes, c_xyPlanes, myPlanes,myJoinedPlanes, th_merge);
    myJoinedPlanes=findAndMergePlanes(j_zyPlanes, c_zyPlanes, myPlanes,myJoinedPlanes, th_merge);
    myPlanes.fr0.values=myJoinedPlanes.fr0.values;
else%initialization of joined planes with planes from the first frame
    fields = fieldnames( myPlanes );
    myPlanes.fr0.values=myPlanes.(fields{2}).values;
    acceptedJPlanes=ids_myPlanes;
    acceptedJPlanes(:,1)=zeros(length(ids_myPlanes),1);
    myPlanes.fr0.acceptedPlanes=acceptedJPlanes;
end
end

