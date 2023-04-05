function gc2 = compute_gc2(plane1,plane2)
%COMPUTE_GC2 computes the distance gc_2 used in the merging of twin planes,
%during the processing of planes. 
% Assumptions
% the planes are of type 1
% all properties of planes are available

p1=maxAPlane(plane1,plane2);
p2=minAPlane(plane1,plane2);

if p1.L2toY
    if p2.L2toY
        gc2=p1.L2-p1.L2/2-p2.L2/2;
    else
        gc2=p1.L2-p1.L2/2-p2.L1/2;
    end
else
    if p2.L2toY
        gc2=p1.L1-p1.L1/2-p2.L2/2;
    else
        gc2=p1.L1-p1.L1/2-p2.L1/2;
    end
end

end

