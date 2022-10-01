function [pc_out] = projectInPlane(pc,modelParameters)
%PROJECTINPLANE projects points in pc into a plane described by
%modeParameters
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
    
end

