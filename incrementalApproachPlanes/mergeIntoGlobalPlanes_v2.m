function [globalPlanes, bufferComposedPlanes] = mergeIntoGlobalPlanes_v2(localPlanes,globalPlanes, tao,...
    theta, lengthBoundsTop, lengthBoundsP, bufferComposedPlanes, tresholdsV, planeModelParameters)
%MERGEINTOGLOBALPLANES performs the seek and merge of planes between the
%elements in vectors localPlanes and globalPlanes. The merged version is
%stored in globalPlanes vector
% ---Input
% 1. localPlanes: vector with descriptors of planes in local scope. size 1xNlp
% 2. globalPlanes: vector with descriptors of planes in global scope size
% 1xNgp
% 3. tao: misalignment tolerance to consider two planes as twins-case1
% 4. theta: threshold for correctness to consider two planes as twins-case1
% 
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
% globalPlane=globalPlanes(1);

for i=1:Nlp
    localPlane=localPlanes(i);%
    twinFlag=false;
    for j=1:Ngp
        globalPlane=globalPlanes(j);
%         plotTypeInPairOfPlanes; %plot script
%         typeOfTwin=computeTypeOfTwin(localPlane,globalPlane, tao, theta);
        typeOfTwin=computeTypeOfTwin_v2(localPlane,globalPlane, tao,...
            theta,lengthBoundsTop, lengthBoundsP, planeModelParameters(1));
        if typeOfTwin~=0
            [globalPlanes,bufferComposedPlanes]=performMerge_v2(localPlane,globalPlanes, j,...
                typeOfTwin, bufferComposedPlanes, tresholdsV, lengthBoundsTop,...
                lengthBoundsP, planeModelParameters);
%             [globalPlanes, localPlanes, bufferComposedPlanes]=performMerge_v3(localPlane,...
%                 globalPlanes, j, i, typeOfTwin, bufferComposedPlanes,...
%                 tresholdsV, lengthBoundsTop, lengthBoundsP, planeModelParameters);
%         if (globalPlane.idPlane==37)
%             disp('hello world from mergeIntoGlobalPlanes_v2')
%         end            
            twinFlag=true;
            continue
        end
    end

    if twinFlag==false
        globalPlanes=[globalPlanes localPlane];%add a new element to global plane
    end
end

end

