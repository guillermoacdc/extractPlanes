function thirdPlaneDetection_v2(myPlanes, acceptedPlanes, th_angle)
%THIRDPLANEDETECTION Performs third plane detection based on the procedure
%described in section 4.2 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id

candidates1={};
candidates2=[];
%% create 3-d tree
exemplarSet=zeros(size(acceptedPlanes,1),3);
for i=1:size(acceptedPlanes,1)
    frame_ss=acceptedPlanes(i,1);
    element_ss=acceptedPlanes(i,2);    
    exemplarSet(i,:)=myPlanes.(['fr' num2str(frame_ss)])(element_ss).unitNormal;
end
% modelTree=KDTreeSearcher(exemplarSet);

%% create thirdPlaneExemplar structure. Input to the 3-d tree in the field crossP
% load detected pairs of plane index
secondPlaneT=[];
for i=1:size(acceptedPlanes,1)
    frame_ss=acceptedPlanes(i,1);
    element_ss=acceptedPlanes(i,2); 
    if(~isempty(myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID))
        secondFrame=myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID(2);
        secondPlaneT=[secondPlaneT; frame_ss,element_ss,...
            secondFrame, secondElement];
    end
end
% eliminate duplicates; we asume the pair (1,3) is duplicated with pair (3,1)
[uniqueIndexes ic]= myUnique_v2(secondPlaneT);
secondPlaneT_unique=secondPlaneT(uniqueIndexes,:);
% assembly in the thirdPlaneExemplar structure
for i=1:size(secondPlaneT_unique,1)
    thirdPlaneExemplar.id=secondPlaneT_unique(i,1:2);
    thirdPlaneExemplar.secondPlaneId=secondPlaneT_unique(i,3:4);
    
    a=myPlanes.(['fr' num2str(thirdPlaneExemplar.id(1))])(thirdPlaneExemplar.id(2)).unitNormal;
    b=myPlanes.(['fr' num2str(thirdPlaneExemplar.secondPlaneId(1))])(thirdPlaneExemplar.secondPlaneId(2)).unitNormal;
%     a=myPlanes{thirdPlaneExemplar.id}.unitNormal;
%     b=myPlanes{thirdPlaneExemplar.secondPlaneId}.unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end



%% perform the search and save the result in myPlanes structure
for i=1:size(secondPlaneT_unique,1)
    
    %     use cross product vector as a query for the kd tree
    candidates1{i}=myRangeSearch(exemplarSet,tPExemplar{i}.crossPd,th_angle*180/pi);
    if (isempty(candidates1{i}))
        continue
    end
    candidates1_v2{i}=extract2dIndexes(candidates1{i}, acceptedPlanes);
%     candidates1_v2{i} = acceptedPlanes(candidates1{i});
    % select candidates by convexity criterion
    candidates2=[];
    k=1;
        for(ii=1:1:length(candidates1{i}))
            targetFrame=secondPlaneT_unique(i,1);
			targetElement=secondPlaneT_unique(i,2);
			secondFrame=secondPlaneT_unique(i,3);
			secondElement=secondPlaneT_unique(i,4);
			candidateFrame=acceptedPlanes(candidates1{i}(ii),1);
			candidateElement=acceptedPlanes(candidates1{i}(ii),2);

if targetFrame==4 && targetElement==11
    disp("stop the world");
end

			%convexity btwn target and candidate
			n1=myPlanes.(['fr' num2str(targetFrame)])(targetElement).unitNormal;
			gc1=myPlanes.(['fr' num2str(targetFrame)])(targetElement).geometricCenter;
			n2=myPlanes.(['fr' num2str(candidateFrame)])(candidateElement).unitNormal;
			gc2=myPlanes.(['fr' num2str(candidateFrame)])(candidateElement).geometricCenter;
			convFlag1=convexityCheck(n1,gc1,n2,gc2);
			%convexity between secondPlane and candidate
			n1=myPlanes.(['fr' num2str(secondFrame)])(secondElement).unitNormal;
			gc1=myPlanes.(['fr' num2str(secondFrame)])(secondElement).geometricCenter;
			convFlag2=convexityCheck(n1,gc1,n2,gc2);
            if (convFlag1 & convFlag2)
                candidates2(k,1)=candidateFrame;
				candidates2(k,2)=candidateElement;
                k=k+1;
            end
        end
        
        if (isempty(candidates2))
            continue
        end
    
        % select candidates by distance criterion (with a single target)
        targetFrame=secondPlaneT_unique(i,1);
		targetElement=secondPlaneT_unique(i,2);
		v1=myPlanes.(['fr' num2str(targetFrame)])(targetElement).geometricCenter;			
		dist_v=[];%clear the distance vector
		for (ii=1:1:size(candidates2,1))
		    candidateFrame=candidates2(ii,1);
			candidateElement=candidates2(ii,2);	
			v2=myPlanes.(['fr' num2str(candidateFrame)])(candidateElement).geometricCenter;
		    dist_v(ii)=norm(v1-v2);
        end
        [~,selectedIndex]=min(dist_v);

        thirdPlaneIndex=[candidates2(selectedIndex,:)];
        
        % retrieve duplicates from unique filter
        dup=find(ic==i);
        % save the thirdplane in the structure cell
        for j=1:length(dup)
            targetFrame=secondPlaneT(dup(j),1);
			targetElement=secondPlaneT(dup(j),2);
			myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID=thirdPlaneIndex;
%             myPlanes{secondPlaneT(dup(j),1)}.thirdPlaneID=thirdPlaneIndex;
        end
end

end





