function Tm = rotH2M(Th)
%ROTH2M Summary of this function goes here
%   Detailed explanation goes here
R1=rotx(-90);
R2=rotz(-90);
% R3=rotz(180);
Tm=Th;
Rh=Th(1:3,1:3);
Rm=Rh*R1*R2;
% Rm=Rh*R1;
% Rm=Rh*R1*R2*R3;
Tm(1:3,1:3)=Rm;
end

