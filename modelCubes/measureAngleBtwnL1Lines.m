function alfa = measureAngleBtwnL1Lines(plane1,plane2)
%MEASUREANGLEBTWNL1LINES Measures the angle between lines L1 of two planes;
%L1 is the side with minor length in the plane
% Assumptions: (1) the inputs are objects from the class plane defined in the
% doctoral project
% (2) The properties of this object are full defined
% (3) The planes belong to the same type/tiltxy

type=plane1.type;
tiltxy=plane1.planeTilt;

if type==0
    v1=plane1.tform(1:3,1);
    v2=plane2.tform(1:3,1);
else
    if tiltxy==0
        v1=plane1.tform(1:3,2);
        v2=plane2.tform(1:3,2);
    else
        v1=plane1.tform(1:3,1);
        v2=plane2.tform(1:3,1);
    end
end

alfa=computeAngleBtwnVectors(v1,v2);
end

