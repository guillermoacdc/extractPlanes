function [x_p] = projectInPlane(x,planeModel,tform)
%PROJECTINPLANE Summary of this function goes here
%   Detailed explanation goes here
% x as a column vector
% taked from https://stackoverflow.com/questions/9605556/how-to-project-a-point-onto-a-plane-in-3d
    A=planeModel(1);
    B=planeModel(2);
    C=planeModel(3);
    D=planeModel(4);
    
   sdistance=dot([A B C],x)+D;
% projection
    x_p=x-(sdistance*[A B C]');%point reflected at raw plane
    x_p_e=tform*[x_p; 1];
    x_p=x_p_e(1:3);
end

