function [numberOfObjects, clusterDescriptor] = countObjectsInPC_v5(sessionID, frameID, typeObject,...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag)
%COUNTOBJECTSINPC Counts the number of objects in a point cloud. 
%   inputs
% 1. typeObjects, 1 for top, 2 for perpendicular
% _v5: returns a struct with descriptors of each cluster: planeModel,
% sessionID, frameID, clusterID, pcCount, 

clusterDescriptor.sessionID=sessionID;
clusterDescriptor.frameID=frameID;

%% load pc from session and frame IDs
[pc_raw]=loadSLAMoutput_v2(sessionID,frameID); %loaded in mm

%% project pc to qm coordinate system
dataSetPath=computeMainPaths(sessionID);
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
% project
pc_m=myProjection_v3(pc_raw,Th2m);

%% delete points that fit with ground plane

[modelGround,inlierIndices]=pcfitplane(pc_m,th_distance,[0 0 1]);
clusterDescriptor.groundNormal=modelGround.Parameters(1:3);
clusterDescriptor.groundD=modelGround.Parameters(4);
% delete inliers
    xyz=pc_m.Location;
    xyz(inlierIndices,:)=[];
    pcwoutGround=pointCloud(xyz);

% filter points by type
    [inliersTopPlane, inliersLateralPlane]=filterPointsByType(pcwoutGround,...
        th_angle);
%% cluster by instance
% form the vector of features X
if typeObject==1%for top planes we use the whole point cloud
% for top planes we delete the lateral planes of each cluster
    xyz(inliersLateralPlane,:)=[];
    pcSingleType=pointCloud(xyz);
else
    % for lateral planes we delete the top side of each cluster
    xyz(inliersTopPlane,:)=[];
    pcSingleType=pointCloud(xyz);
end
cosAlpha=computeCosAlpha(pcSingleType,[0 0 1]);
X=[pcSingleType.Location(:,1), pcSingleType.Location(:,2), ...
pcSingleType.Location(:,3), cosAlpha];


% cluster
idx = dbscan(X,epsilon,minpts);

%% return  number of objects
numberOfObjects=max(idx);

if typeObject==1

%     compute distance of cluster to origin
    distance=zeros(numberOfObjects,1);

        for i=1:numberOfObjects
                rows=find(idx==i);
                tempPC=pointCloud(pcSingleType.Location(rows,:));
                clusterDescriptor.('PCCount')(i)=tempPC.Count;
                xmean=mean(pcSingleType.Location(rows,:));
                distance(i)=norm(xmean);
                if plotFlag
                    pcshow(tempPC);
                    text(xmean(1),xmean(2),xmean(3),num2str(i),'Color','yellow');
                    hold on
                end
        end
% filter clusterDescriptor.ID by distance 
    badDetections=0;
    clusterDescriptor.ID=[];
        for i=1:numberOfObjects
            if abs(distance(i))>th_distance2
                badDetections=badDetections+1;
            else
                clusterDescriptor.ID=[clusterDescriptor.ID i];
            end
        end
        numberOfObjects=length(clusterDescriptor.ID);
        % fit clusterDescriptor.ID with plane model
        for i=1:numberOfObjects
                rows=find(idx==clusterDescriptor.ID(i));
                myrows.(['cluster' num2str(i)])=rows;
                pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
                    pcSingleType.Location(rows,3)]);
                clusterDescriptor.('planeModel'){i} =pcfitplane(pc_i,th_distance);
        end


else
    %% fit clusterDescriptor.ID with plane model
    k=1;
    for i=1:numberOfObjects
        rows=find(idx==i);
        myrows.(['cluster' num2str(k)])=rows;
        pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
        [planeModel_temp, ~, outlierIndicesCluster] =pcfitplane(pc_i,th_distance);
        clusterDescriptor.('planeModel'){k}=planeModel_temp;
        k=k+1;
        if length(outlierIndicesCluster)>minpts/2
            rows=rows(outlierIndicesCluster);
            myrows.(['cluster' num2str(k)])=rows;
            pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
            planeModel_temp =pcfitplane(pc_i,th_distance);
            clusterDescriptor.('planeModel'){k}=planeModel_temp;
            k=k+1;
        end
    end
    numberOfObjects=k-1;
    % compute distance D
    distanceD=zeros(numberOfObjects,1);
    for i=1:numberOfObjects
        distanceD(i)=clusterDescriptor.planeModel{i}.Parameters(4);
    end
    % filter clusterDescriptor.ID by distance D
    badDetections=0;
    clusterDescriptor.ID=[];
    for i=1:numberOfObjects
        if abs(distanceD(i))>th_distance2
            badDetections=badDetections+1;
        else
            clusterDescriptor.ID=[clusterDescriptor.ID i];
        end
    end
    numberOfObjects=numberOfObjects-badDetections;
%     % remove filtered clusters
%     removeIDs=setdiff(1:max(k-1),clusterDescriptor.ID);
%     clusterDescriptor.{removeIDs}=[];
    
    if plotFlag
        figure,
            for i=1:numberOfObjects+badDetections
                rows=myrows.(['cluster' num2str(i)]);
    %             myRows.(['cluster' num2str(i)])=rows;
                tempPC=pointCloud(pcSingleType.Location(rows,:));
                charArray=dec2bin(i,3);
                color=[ str2num(charArray(1)),  str2num(charArray(2)),  str2num(charArray(3))]*255;
                tempPC=pcPaint(tempPC,color);
                pcshow(tempPC);
%                 myLegends(i)={['cluster ' num2str(i)]};
                xmean=mean(pcSingleType.Location(rows,:));
                text(xmean(1),xmean(2),xmean(3),num2str(i),'Color','yellow');
                 hold on
            end
                xlabel 'x'
                ylabel 'y'
                grid
            title ([ num2str(numberOfObjects) ' objects in the frameID '...
                num2str(frameID) ': clusterDescriptor.ID ' num2str(clusterDescriptor.ID)])
    end
end


% if plotFlag
%     figure,
%         pcshow(pcwoutGround)
%         hold on
%         dibujarsistemaref(eye(4),'m',250,2,10,'w');
%         grid on
%         xlabel 'x'
%         ylabel 'y'
%         zlabel 'z'
%         title (['pc wout ground sessionID/frameID ' num2str(sessionID) '/' num2str(frameID)])
% 
% end

end

