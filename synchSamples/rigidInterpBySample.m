function interpolatedPos = rigidInterpBySample(markerID,distanceRef,rootPath,scene)
%RIGIDINTERPBYSAMPLE Summary of this function goes here
%   Detailed explanation goes here

pB_candidates=loadDistanceBtwnMarkers(rootPath,scene);
switch markerID
   case 0
        pB=pB_candidates(1,:)';
   case 4
        pB=pB_candidates(2,:)';
   case 5
        pB=pB_candidates(3,:)';
   case 6
        pB=pB_candidates(4,:)';

end

TB2A=eye(4);
TB2A(1:3,4)=distanceRef;
interpolatedPos=TB2A*pB;
interpolatedPos(end)=[];

end

