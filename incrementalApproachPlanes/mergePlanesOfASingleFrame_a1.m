function [vectorOfPlanes]=mergePlanesOfASingleFrame_a1(vectorOfPlanes, th_IoU, th_coplanarDistance)
%MERGEPLANESOFASINGLEFRAME Performs the selection of pair of planes with IoU 
% greater than a threshold. The plane with greater fitness is selected


NlocalPlanes=size(vectorOfPlanes,2);

if NlocalPlanes==1
	Npairs=0;
else
	nonRepeatedPairs=nchoosek(1:NlocalPlanes,2);
	Npairs=size(nonRepeatedPairs,1);
end

myCounter=Npairs;

i=1;
indexToDelete=[];
while myCounter>=1
    planeA=vectorOfPlanes(nonRepeatedPairs(i,1));
    planeB=vectorOfPlanes(nonRepeatedPairs(i,2));
    [~, coplanarDistance]=computeDistanceBtwnPlanes(planeA,planeB);
    IoU=measureIoUbtwnPlanes(planeA,planeB);
    
    if IoU>th_IoU & coplanarDistance<th_coplanarDistance
        disp('deleting a twin plane from a single frame')
        if planeA.fitness>planeB.fitness
%             delete planeB from vector
            indexToDelete=[indexToDelete nonRepeatedPairs(i,2)];
        else
%             delete planeA from vector
            indexToDelete=[indexToDelete nonRepeatedPairs(i,1)];
        end
       
    end
    myCounter=myCounter-1;
    i=i+1;
end

if ~isempty(indexToDelete)
    vectorOfPlanes(indexToDelete)=[];
end

end

