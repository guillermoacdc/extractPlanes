function a=computeAngleBtwnVectors(P1,P2)

% returns values in the closed interval [-180,180]

% https://www.youtube.com/watch?v=QWIZXRjMspI

% P1=[8 0 0];
% P2=[4 4 0];

a = atan2(norm(cross(P1,P2)),dot(P1,P2)); % Angle in radians
a=a*180/pi;%angle in degrees