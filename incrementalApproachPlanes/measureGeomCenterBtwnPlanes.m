function d = measureGeomCenterBtwnPlanes(plane1,plane2)
%MEASUREGEOMCENTERBTWNPLANES Measure de geometri center between two planes
%in R3. The planes belong to the class plane defined for the doctoral
%project. The distance is an scalar

d=norm(plane1.geometricCenter-plane2.geometricCenter);


end

