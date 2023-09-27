function Nplanes=countPlanes(visiblePlanesByFrame)
%COUNTPLANES Summary of this function goes here
%   Detailed explanation goes here
Nboxes=size(visiblePlanesByFrame,1);
Nplanes=0;
for i=1:Nboxes
    N=length(visiblePlanesByFrame(i).planesID);
    Nplanes=Nplanes+N;
end
end

