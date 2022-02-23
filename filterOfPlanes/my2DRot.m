function [rotatedData gc] = my2DRot(data,theta)
%MY2DROT Summary of this function goes here
%   Detailed explanation goes here
R=[cos(theta) -sin(theta); sin(theta) cos(theta)];
for(i=1:size(data,1))
    rotatedData(i,:)=R*data(i,:)';
end
gc=[mean(rotatedData(:,1)), mean(rotatedData(:,2))];

end

