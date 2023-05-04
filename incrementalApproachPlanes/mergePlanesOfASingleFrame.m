function [vectorOfPlanes,bufferCP]=mergePlanesOfASingleFrame(vectorOfPlanes,bufferCP, tresholdsV,...
    lengthBoundsTop, lengthBoundsP, planeModelParameters)
%MERGEPLANESOFASINGLEFRAME Performs the merge of pair of planes with type 4.
%This type exists when two point clouds must be merge. The new point cloud
%is used to compute plane parameters, then is destructed. The relationship
%between merged planes and its componets is saved in the vectorOfPlanes
%descriptors. The vector bufferCP saves descriptors of the components. 

% vectorOfPlanes: vector with planes objects of a single frame; can be
% local or global
% bufferCP: vector of component planes
% planeModelParameters: vector with thresholds to extract plane models
% tresholdV: vector with thresholds to filter extracted planes
% lengthBoundsX: previous knowledge of max size in Top and Perpendicular
% planes




sessionID=vectorOfPlanes(1).idScene;
th_lenght=tresholdsV(1);
th_size=tresholdsV(2);
th_occlusion=tresholdsV(4);
maxDistance=planeModelParameters(1);
maxAngularDistance=planeModelParameters(2);
referenceVector=planeModelParameters(3:end);


NlocalPlanes=size(vectorOfPlanes,2);
% nonRepeatedPairs=nchoosek(1:NlocalPlanes,2);
% Npairs=size(nonRepeatedPairs,1);
if NlocalPlanes==1
	Npairs=0;
else
	nonRepeatedPairs=nchoosek(1:NlocalPlanes,2);
	Npairs=size(nonRepeatedPairs,1);
end

myCounter=Npairs;

i=1;
while myCounter>=1
    planeA=vectorOfPlanes(nonRepeatedPairs(i,1));
    planeB=vectorOfPlanes(nonRepeatedPairs(i,2));

    if(planeA.type==0)
        maxTopSize=sqrt(lengthBoundsTop(1)^2+lengthBoundsTop(2)^2);%update 
    else
        maxTopSize=sqrt(lengthBoundsP(1)^2+lengthBoundsP(2)^2);%update 
    end
    type4=isType4(planeA,planeB, maxTopSize,planeModelParameters(1));
    if type4

    %%   add components to the bufferCP vector
%         Ncomp=size(buffer,2);
        Ncomp=computeMaxNcomposedIDPlane(bufferCP);
%         planeA.composed_idFrame=0;
%         planeA.composed_idPlane=Ncomp+1;
%         planeB.composed_idFrame=0;
%         planeB.composed_idPlane=Ncomp+1;
        bufferCP = updateBufferCP(planeA,planeB, bufferCP, Ncomp);
%         bufferCP=[bufferCP planeA planeB];
    %%   delete id of components from vectorOfPlanes
        indexA=extractIndexFromIDs(vectorOfPlanes,planeA.idFrame,planeA.idPlane);
        indexB=extractIndexFromIDs(vectorOfPlanes,planeB.idFrame,planeB.idPlane);
        vectorOfPlanes(indexB)=[];
        vectorOfPlanes(indexA)=[];
    %%   compute parameters of the composed plane and write them to vectorOfPlanes
        % create the new point cloud
%         pcA=myPCread(planeA.pathPoints);
%         pcB=myPCread(planeB.pathPoints);
        pcA=myPCreadComposedPlane(planeA.pathPoints, planeA.idFrame, planeA.idPlane, bufferCP);
        pcB=myPCreadComposedPlane(planeB.pathPoints, planeB.idFrame, planeB.idPlane, bufferCP);
        pcnew=pcmerge(pcA,pcB,0.1);%mm
        
        % compute paramaters of plane model from the new pointcloud
%         maxDistance=0.1*1000;%mm
%         maxAngularDistance=5;%deg
%         referenceVector=[0 1 0];
        model = pcfitplane(pcnew,maxDistance,referenceVector,maxAngularDistance);

        newParameters=[model.Parameters 0, 0, 0]; %is assumed that the geometric center will be
 
    %   create a new composed plane, with double value in its IDs

%         condicionar almacenamieto de pathPoints. En caso de que planeX
%         sea compuesto, recuperar los componentes y armar un cell único.
%         Esto para que la función soft de carga de PCs opere
        newPath = computePathMergedPlane(planeA.pathPoints,planeB.pathPoints);
        composedPlane=plane(sessionID,0,...
                Ncomp+1,newParameters,...
                newPath,pcnew.Count);


        % classify the plane object
            % inherit basic properties
                composedPlane.type=planeA.type;
                if composedPlane.type==1
                    composedPlane.L2toY=planeA.L2toY;
                    composedPlane.planeTilt=planeA.planeTilt;
                end
            
                % set limits and update geometric center. The update is necessary to include the projection of points to
                %     the plane model before compute g.c. 
                composedPlane.setLimits(pcnew);%set limits in each axis.
                %     detect antiparallel normals and correct
                composedPlane.correctAntiparallel(th_size);%
                % measure pose and length, and updata occlusion flag
                composedPlane.measurePoseAndLength(pcnew, th_occlusion, 0);
                % set length flag based on type of plane
                if composedPlane.type==0
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsTop,th_lenght);
                else
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsP,th_lenght);
                end
                composedPlane.setLengthFlag(lengthFlag);
            

%%   insert composedPlane into vectorOfPlanes
if composedPlane.idPlane==37
    disp('stop from mergePlanesOfASingleFrame')
end
        vectorOfPlanes=[vectorOfPlanes composedPlane];
%% update nonRepeatedPairs and reset counters
        NlocalPlanes=size(vectorOfPlanes,2);
        nonRepeatedPairs=nchoosek(1:NlocalPlanes,2);
        Npairs=size(nonRepeatedPairs,1);
        myCounter=Npairs;
        i=0;
    else
        myCounter=myCounter-1;
    end
    i=i+1;
end

end

