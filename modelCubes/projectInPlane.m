function [pc_out] = projectInPlane(pc,modelParameters)
%PROJECTINPLANE Summary of this function goes here
%   Detailed explanation goes here
% taked from https://stackoverflow.com/questions/9605556/how-to-project-a-point-onto-a-plane-in-3d
    A=modelParameters(1);
    B=modelParameters(2);
    C=modelParameters(3);
    D=modelParameters(4);
%     preallocating memory for p variable
    p=zeros(pc.Count,3);
for i=1:pc.Count
    x=pc.Location(i,:)';%column vector
    sdistance=dot([A B C],x)+D;
    % projection
    p(i,:)=(x-(sdistance*[A B C]'))';%point reflected at parametrized plane- row vector
end
    pc_out=pointCloud(p);
    
    
%    sdistance=dot([A B C],x)+D;
% projection
%     x_p=x-(sdistance*[A B C]');%point reflected at raw plane
%     x_p_e=tform*[x_p; 1];
%     x_p=x_p_e(1:3);
end

