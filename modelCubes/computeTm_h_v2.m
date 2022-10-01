function Tm_h = computeTm_h_v2(Tc_h, Tc_m)
%COMPUTETM_H Computes transformation matrix between hololens world and
%mocap world. 
%   Returns distances in mm and angles in degrees

% perform computation
Tm_h=inv(Tc_m)*Tc_h;

end

