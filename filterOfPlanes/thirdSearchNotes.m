function thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)
%THIRDPLANEDETECTION Performs third plane detection based on the procedure
%described in section 4.2 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

%% create thirdPlaneExemplar structure. Input to the 3-d tree in the field crossP
% load detected pairs of plane index
secondPlaneT=[];
for i=1:length(acceptedPlanes)
    if(~isempty(myPlanes{acceptedPlanes(i)}.secondPlaneID))
        secondPlaneT=[secondPlaneT; myPlanes{acceptedPlanes(i)}.idPlane,...
            myPlanes{acceptedPlanes(i)}.secondPlaneID];
    end
end
% eliminate duplicates; we asume the pair (1,3) is duplicated with pair (3,1)
[uniqueIndexes ic]= myUnique(secondPlaneT);
secondPlaneT_unique=secondPlaneT(uniqueIndexes,:);
% assembly in the thirdPlaneExemplar structure
for (i=1:length(secondPlaneT_unique))
    thirdPlaneExemplar.id=secondPlaneT_unique(i,1);
    thirdPlaneExemplar.secondPlaneId=secondPlaneT_unique(i,2);
    a=myPlanes{thirdPlaneExemplar.id}.unitNormal;
    b=myPlanes{thirdPlaneExemplar.secondPlaneId}.unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end

%% create 3-d tree
exemplarSet=zeros(length(acceptedPlanes),3);
for i=1:length(acceptedPlanes)
    exemplarSet(i,:)=myPlanes{acceptedPlanes(i)}.unitNormal;
end
modelTree=KDTreeSearcher(exemplarSet);

%% perform the search and save the result in myPlanes structure
for i=1:length(secondPlaneT_unique)
%     use cross product vector as a query for the kd tree
% candidates1(i)=knnsearch(modelTree,tPExemplar{i}.crossPd);
% candidates1(i)=rangesearch(modelTree,tPExemplar{i}.crossPd,th_angle/100);
candidates1(i)=rangesearch(modelTree,tPExemplar{i}.crossPd,th_angle);



    if ~isempty(candidates1{i})
    % Check candidates with convexity criterion ()
        n1=myPlanes{secondPlaneT_unique(i,1)}.unitNormal;
        gc1=myPlanes{secondPlaneT_unique(i,1)}.geometricCenter;
        n2=myPlanes{acceptedPlanes(candidates1{i})}.unitNormal;
        gc2=myPlanes{acceptedPlanes(candidates1{i})}.geometricCenter;
            convFlag1=convexityCheck(n1,gc1,n2,gc2);
        n1=myPlanes{secondPlaneT_unique(i,2)}.unitNormal;
        gc1=myPlanes{secondPlaneT_unique(i,2)}.geometricCenter;
            convFlag2=convexityCheck(n1,gc1,n2,gc2);
        if(convFlag1 & convFlag2)
            % Apply proximity check (pendent)
            

            % retrieve duplicates from unique filter
            dup=find(ic==i);
            % save the thirdplane in the structure cell
            for j=1:length(dup)
                myPlanes{secondPlaneT(dup(j),1)}.thirdPlaneID=acceptedPlanes(candidates1{i});
            end
            % [secondPlaneT_unique(i,:) acceptedPlanes(candidates1{i})]
        end
    
    end

end



end

