function globalPlanes = mergeIntoGlobalPlanes(localPlanes,globalPlanes, tao, theta)
%MERGEINTOGLOBALPLANES performs the seek and merge of planes between the
%elements in vectors localPlanes and globalPlanes. The merged version is
%stored in globalPlanes vector
% ---Input
% 1. localPlanes: vector with descriptors of planes in local scope. size 1xNlp
% 2. globalPlanes: vector with descriptors of planes in global scope size
% 1xNgp
% 3. dc_l: vector of distances between camera and local planes
% 4. dc_g: vector of distances between camera and global planes
% ---Output
% globaPlanes. vector with updated elements: (1) merged version of non
% occluded planes, (2) splitted version of overimposed planes, (3) merged
% version of partial occluded planes
% ---Assumptions
% 1. the elements in input vectors, are objects from plane class
% 2. the elements in iput vectors has the same value for type property. 
% 3. the input lengths are in the same units (i.e. millimeters)

Nlp=size(localPlanes,2);
Ngp=size(globalPlanes,2);
globalPlane=globalPlanes(1);

for i=1:Nlp
    localPlane=localPlanes(i);%
    twinFlag=false;
    for j=1:Ngp
        globalPlane=globalPlanes(j);
%         plotTypeInPairOfPlanes; %plot script
%         if (localPlane.idPlane==2 & globalPlane.idPlane==7)
%             disp('hello world')
%         end
        typeOfTwin=computeTypeOfTwin(localPlane,globalPlane, tao, theta);
        if typeOfTwin~=0
            globalPlanes=performMerge(localPlane,globalPlanes, j, typeOfTwin);
            twinFlag=true;
%             j=Ngp;%do not work to break the for loop. Use continue
            continue
        end
    end

    if twinFlag==false
        globalPlanes=[globalPlanes localPlane];%add a new element to global plane
    end
end

end

