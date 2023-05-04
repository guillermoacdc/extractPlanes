particlesVector=[];
radii=15;%mm
windowSize=10;%frames
[globalPlanes,particlesVector] = temporalPlanesFiltering(globalPlanes,particlesVector, radii, frameID, windowSize)