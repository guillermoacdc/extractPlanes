function adjustPoseOrthogonal(globalPlanes,group_tpp)
%ADJUSTPOSEORTHOGONAL Perform and adjust in the three planes that compose a
%box, to warrant orthogonality between them

% ---vs2
rtop=globalPlanes(group_tpp(1)).tform(1:3,1:3);



    % plano que se ubica en la zona positiva del vector z del plano superior:
    % el error de rotación debe ser pqño (max 18 grados) -- 11 para el caso
    % prueba
    globalPlanes(group_tpp(3)).tform(1:3,1:3)=rtop;
    
    % plano que se ubica en la zona positiva del vector x del plano superior:
    % el error de rotación debe estar aproximandose a 90 grados -- 102 para el
    % caso prueba
    globalPlanes(group_tpp(2)).tform(1:3,1:3)=roty(90)*rtop;

end

% % ---vs1
% % compute thetap1; angle that top and perpendicualar1 planes must rotate
% xtop=globalPlanes(group_tpp(1)).tform(1:3,2);
% xp1=globalPlanes(group_tpp(2)).tform(1:3,3);
% thetap1=computeAngleBtwnVectors(xtop,xp1)/2;%in degrees
% figure
% quiver3(0,0,0,xtop(1), xtop(2),xtop(3))
% hold
% quiver3(0,0,0,xp1(1), xp1(2),xp1(3))
% 
% 
% % perform rotation on top and perpendicular 1 plane
% % globalPlanes(group_tpp(1)).tform(1:3,1:3)=roty(thetap1)*globalPlanes(group_tpp(1)).tform(1:3,1:3);
% % globalPlanes(group_tpp(2)).tform(1:3,1:3)=roty(-thetap1)*globalPlanes(group_tpp(2)).tform(1:3,1:3);
% globalPlanes(group_tpp(1)).tform(1:3,1:3)=globalPlanes(group_tpp(1)).tform(1:3,1:3)*roty(thetap1);
% globalPlanes(group_tpp(2)).tform(1:3,1:3)=globalPlanes(group_tpp(2)).tform(1:3,1:3)*roty(-thetap1);
% 
% % compute thetap2; angle that perpendicular1 plane must rotate
% ztop=globalPlanes(group_tpp(1)).tform(1:3,3);
% xp2=globalPlanes(group_tpp(3)).tform(1:3,1);
% thetap2=abs(180-computeAngleBtwnVectors(ztop,xp2));%in degrees
% 
% % perform rotation
% globalPlanes(group_tpp(3)).tform(1:3,1:3)=roty(-thetap2)*globalPlanes(group_tpp(3)).tform(1:3,1:3);


