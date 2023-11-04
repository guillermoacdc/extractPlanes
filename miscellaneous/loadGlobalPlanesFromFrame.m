function [myPlanes] = loadGlobalPlanesFromFrame(allTopPlanes,allPerpendicularPlanes, frameID)
%LOADGLOBALPLANESFROMFRAME load global planes from an specific frame

topPlanes= allTopPlanes.(['frame' num2str(frameID)]);
perpendicularPlanes=allPerpendicularPlanes.(['frame' num2str(frameID)]);

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

