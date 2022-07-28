function planeMaxA = maxAPlane(plane1, plane2)
%MAXAPLANE Computes the plane with maximal area and returns this plane
% assumptions: just two inputs
% the inputs are objects from the class plane defined in the doctoral
% project
A1=plane1.L1*plane1.L2;
A2=plane2.L1*plane2.L2;
if A1>A2
    planeMaxA=plane1;
else
    planeMaxA=plane2;
end

end

