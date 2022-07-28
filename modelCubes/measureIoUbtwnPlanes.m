function IoU = measureIoUbtwnPlanes(plane1,plane2)
%MEASUREIOUBTWNPLANES Measures the intersection over union (IoU) between
%two planes
% Assumptions: the planes have the same type
% the planes are objects from the class plane used in the doctoral project
% the planes has all their properties filled

type=plane1.type;

if type
    plane1s=gcLength2corners(plane1);
    plane2s=gcLength2corners(plane2);
    IoU=computeIOU(plane1s,plane2s);
else%top planes
    pt1=extract2DPoints(plane1);
    pt2=extract2DPoints(plane2);
    poly1=polyshape(pt1(:,1)', pt1(:,2)');
    poly2=polyshape(pt2(:,1)', pt2(:,2)');
    polyIntersection=intersect(poly1,poly2);
    polyUnion=union(poly1,poly2);
    IoU=area(polyIntersection)/area(polyUnion);
end

end

