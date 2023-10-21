function [myPlanes] = loadGlobalPlanesFromFrame(topPlanes,perpendicularPlanes)
%LOADGLOBALPLANESFROMFRAME load global planes from an specific frame

if ~isempty(topPlanes)
    if ~isempty(perpendicularPlanes)
        myPlanes.values=[topPlanes.values; perpendicularPlanes.values];
        myPlanes.Nnap=topPlanes.Nnap+perpendicularPlanes.Nnap;
    else
        myPlanes.values=topPlanes.values;
        myPlanes.Nnap=topPlanes.Nnap;
    end
else
    myPlanes.values=perpendicularPlanes.values;
    myPlanes.Nnap=perpendicularPlanes.Nnap;
end

end

