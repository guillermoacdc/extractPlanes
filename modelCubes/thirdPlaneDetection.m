function thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)
%THIRDPLANEDETECTION Performs third plane detection based on the procedure
%described in section 4.2 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

candidates1={};
candidates2=[];
%% create 3-d tree
exemplarSet=zeros(length(acceptedPlanes),3);
for i=1:length(acceptedPlanes)
    exemplarSet(i,:)=myPlanes{acceptedPlanes(i)}.unitNormal;
end
modelTree=KDTreeSearcher(exemplarSet);

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
for i=1:size(secondPlaneT_unique,1)
    thirdPlaneExemplar.id=secondPlaneT_unique(i,1);
    thirdPlaneExemplar.secondPlaneId=secondPlaneT_unique(i,2);
    a=myPlanes{thirdPlaneExemplar.id}.unitNormal;
    b=myPlanes{thirdPlaneExemplar.secondPlaneId}.unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end



%% perform the search and save the result in myPlanes structure
for i=1:size(secondPlaneT_unique,1)
    
    %     use cross product vector as a query for the kd tree
%     candidates1(i)=rangesearch(modelTree,tPExemplar{i}.crossPd,th_angle/100);
%     candidates1(i)=rangesearch(exemplarSet,tPExemplar{i}.crossPd,th_angle/100);    
    candidates1{i}=myRangeSearch(exemplarSet,tPExemplar{i}.crossPd,th_angle);
    if (isempty(candidates1{i}))
        continue
    end
%     length(candidates1{i})
    % select candidates by convexity criterion
    candidates2=[];
    k=1;
        for(ii=1:1:length(candidates1{i}))
            %convexity btwn target and candidate
            n1=myPlanes{secondPlaneT_unique(i,1)}.unitNormal;
            gc1=myPlanes{secondPlaneT_unique(i,1)}.geometricCenter;
            n2=myPlanes{acceptedPlanes(candidates1{i}(ii))}.unitNormal;
            gc2=myPlanes{acceptedPlanes(candidates1{i}(ii))}.geometricCenter;
            convFlag1=convexityCheck(n1,gc1,n2,gc2);
            %convexity between secondPlane and candidate
            n1=myPlanes{secondPlaneT_unique(i,2)}.unitNormal;
            gc1=myPlanes{secondPlaneT_unique(i,2)}.geometricCenter;
            convFlag2=convexityCheck(n1,gc1,n2,gc2);
    
            if (convFlag1 & convFlag2)
                candidates2(k)=ii;
                k=k+1;
            end
        end
        
        if (isempty(candidates2))
            continue
        end
    
        % select candidates by distance criterion (with a single target)
        targetPlane=secondPlaneT_unique(i,1);
        v1=myPlanes{targetPlane}.geometricCenter;
        for (ii=1:1:length(candidates2))
            v2=myPlanes{acceptedPlanes( candidates1{i}(ii) ) }.geometricCenter;
            dist_v(ii)=norm(v1-v2);
        end
        [~,selectedIndex]=min(dist_v);
        thirdPlaneIndex=acceptedPlanes(candidates1{i}(selectedIndex));
        
        % retrieve duplicates from unique filter
        dup=find(ic==i);
        % save the thirdplane in the structure cell
        for j=1:length(dup)
            myPlanes{secondPlaneT(dup(j),1)}.thirdPlaneID=thirdPlaneIndex;
        end
end

end





