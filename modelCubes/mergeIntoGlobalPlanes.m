function globalPlanes = mergeIntoGlobalPlanes(localPlanes,globalPlanes,dc_l, dc_g)
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
% 2. the elements in iput vectors has the same type property. 

Nlp=size(localPlanes,2);
Ngp=size(globalPlanes,2);
globalPlane=globalPlanes(1);

for i=1:Nlp
    if (i==4)
        display('stop the code')
    end
    localPlane=localPlanes(i);

    distance_c_l=dc_l(i);
    twinFlag=false;
    for j=1:Ngp
        globalPlane=globalPlanes(j);

%         if localPlane.idFrame(1)==5 & localPlane.idPlane==3 & globalPlane.idFrame==2 & globalPlane.idPlane==11 
%             disp("I am in your case!")
%         end

        typeOfTwin=computeTypeOfTwin(localPlane,globalPlane);
        if typeOfTwin~=0
%             A_l=localPlane.L1*localPlane.L2;
%             A_g=globalPlane.L1*globalPlane.L2;
             
            distance_c_g=dc_g(j);
            globalPlanes=performMerge(localPlane,globalPlanes, j, typeOfTwin, distance_c_l, distance_c_g);
            twinFlag=true;
            j=Ngp;
        end
    end
    if twinFlag==false
        globalPlanes=[globalPlanes localPlane];%add a new element to global plane
    end
end

end

