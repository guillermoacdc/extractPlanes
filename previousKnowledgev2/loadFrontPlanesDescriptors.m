function myPlanes_ref=loadFrontPlanesDescriptors(Nb,boxLengths, initialPoses, scene, myPlanes_ref)
%LOADTOPFLAGDESCRIPTORS Summary of this function goes here
%   Detailed explanation goes here

for i=1:Nb
    [L1,L2]=computePlaneLengthsFromGTBox(boxLengths(i,2:4),1);
    H=boxLengths(i,2);
    myPlanes(i)=createPlaneObject_v2(initialPoses(i,:),[L1 L2 H], 0);
    myPlanes(i).idBox=initialPoses(i,1);
    myPlanes(i).idFrame=0;
    myPlanes(i).idPlane=5;%5 is the id for top planes
    myPlanes(i).idScene=scene;
    if L2==boxLengths(i,2)
        myPlanes(i).L2toY=true;
    else
        myPlanes(i).L2toY=false;
    end
end

myPlanes_ref=[myPlanes_ref myPlanes];

end

