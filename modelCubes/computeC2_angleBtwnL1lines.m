function [c2] = computeC2_angleBtwnL1lines(currentPlane,joinedPlane,th_angle)
%COMPUTEC2_ANGLEBTWNL1LINES Summary of this function goes here
%   Detailed explanation goes here

% compute Line1 for current plane
Line1_cp=currentPlane.tform([1:3],1);
% compute Line1 for joined plane
Line1_jp=joinedPlane.tform([1:3],1);
% compute angle between L1 lines
a=computeAngleBtwnVectors(Line1_cp, Line1_jp);

if a<th_angle
    c2=true;
else
    c2=false;
end

end

