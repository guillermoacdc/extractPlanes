function a=computeAngleBtwnVectors(P1,P2)

% reference
% https://www.youtube.com/watch?v=QWIZXRjMspI

% bugs:
% 1. Se pierde el signo del ángulo en casos de ángulos negativos.
% 2. En ángulos por fuera del rango [0,180], retorna el complemento 360,
% ejm
%       ExpectedAngle=190; ResultedAngle=170. Note que retorna el
%       complemento 360 del ángulo

a = atan2(norm(cross(P1,P2)),dot(P1,P2)); % Angle in radians
a=a*180/pi;%angle in degrees --- % returns values in the closed interval [0,180]
