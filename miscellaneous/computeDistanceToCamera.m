function [distance, er, alpha, beta, gamma] = computeDistanceToCamera(myPlanes,ID)
%COMPUTEDISTANCETOCAMERA Compute the distance between the geometric center 
% of a plane with identifier ID and the camera that mapped that plane
% inputs
% Assumptions: 
% myPlanes
% identifier ID: bidimensional; 
% Update 1. ----Handle vectors of IDs with size Nx2
% Update 2. ----New outputs 
% % er: rotation error btwn camera and object frame
% % alpha> angle that must be rotated along x axis to align estimated plane
% with reference plane
% % beta> angle that must be rotated along y axis to align estimated plane
% with reference plane
% % gamma> angle that must be rotated along z axis to align estimated plane
% with reference plane

N=size(ID, 1);
distance=zeros(N,1);
for i=1:N
    frame=ID(i,1);
    element=ID(i,2);
    cpos=myPlanes.(['fr' num2str(frame)]).cameraPose(1:3,4);
    ppos=myPlanes.(['fr' num2str(frame)]).values(element).tform(1:3,4);
    distance(i)=norm(cpos-ppos);
    %rotation of detected plane
    R1=myPlanes.(['fr' num2str(frame)]).values(element).tform(1:3,1:3);
    %rotation of camera
    R2=myPlanes.(['fr' num2str(frame)]).cameraPose(1:3,1:3);
    er(i)=acos((trace(R1'*R2)-1)/2)*180/pi;
    
    %compute of rotation between estimated and reference value
    R=myRotationSolver(R1,R2);
    % conversion from roation matrix to euler angles
    eul=rotm2eul(R);%returns Euler rotation angles in radians
    % sort output angles by sequence x, y, z, and convert to degrees
    alpha(i)=eul(3)*180/pi;
    beta(i)=eul(2)*180/pi;
    gamma(i)=eul(1)*180/pi;

end



end

