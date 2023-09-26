function [numberOfObjects] = countObjectsInPC(sessionID, frameID, typeObject,...
    th_angle, th_distance, epsilon, minpts, plotFlag)
%COUNTOBJECTSINPC Counts the number of objects in a point cloud. 
%   inputs
% 1. typeObjects, 1 for top, 2 for perpendicular

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

[~,inlierIndices]=pcfitplane(pc_m,th_distance,[0 0 1]);
% delete inliers
    xyz=pc_m.Location;
    xyz(inlierIndices,:)=[];
    pcwoutGround=pointCloud(xyz);

%% filter points based on typeObject
% estimate normals of each point
normalV=pcnormals(pcwoutGround);
[inliersFilter, outliersFilter, cosAlpha]=filterPointsByType(pcwoutGround,...
    normalV,typeObject,th_angle);
% delete outliers from xyz or pcwoutGround
    xyz(inliersFilter,:)=[];
    pcSingleType=pointCloud(xyz);

%% cluster by instance
if typeObject==1
    X=[pcwoutGround.Location(:,1), pcwoutGround.Location(:,2), ...
    pcwoutGround.Location(:,3), cosAlpha];
else
    X=[pcSingleType.Location(:,1), pcSingleType.Location(:,2), ...
    pcSingleType.Location(:,3), cosAlpha(outliersFilter)];

end


% epsilon=100;
% minpts=80;
idx = dbscan(X,epsilon,minpts);

%% return  number of objects
numberOfObjects=max(idx);

if typeObject==1
%     numberOfObjects=max(idx);
%     compute distance of cluster to origin
    distance=zeros(numberOfObjects,1);

        for i=1:numberOfObjects
                rows=find(idx==i);
                tempPC=pointCloud(pcwoutGround.Location(rows,:));
                xmean=mean(pcwoutGround.Location(rows,:));
                distance(i)=norm(xmean);
                if plotFlag
                    pcshow(tempPC);
                    text(xmean(1),xmean(2),xmean(3),num2str(i),'Color','yellow');
                    hold on
                end
        end
% filter clusters by distance 
    badDetections=0;
    clusters=[];
        for i=1:numberOfObjects
            if abs(distance(i))>2600
                badDetections=badDetections+1;
            else
                clusters=[clusters i];
            end
        end
        numberOfObjects=numberOfObjects-badDetections;
else
    %% fit clusters with plane model
    k=1;
    for i=1:numberOfObjects
        rows=find(idx==i);
        myrows.(['cluster' num2str(k)])=rows;
        pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
        [myModel.(['cluster' num2str(k)]), ~, outlierIndicesCluster] =pcfitplane(pc_i,th_distance);
        k=k+1;
        if length(outlierIndicesCluster)>minpts/2
            rows=rows(outlierIndicesCluster);
            myrows.(['cluster' num2str(k)])=rows;
            pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
            [myModel.(['cluster' num2str(k)]), inlierIndicesCluster, outlierIndicesCluster] =pcfitplane(pc_i,th_distance);
            k=k+1;
        end
    end
    numberOfObjects=k-1;
    % compute distance D
    distanceD=zeros(numberOfObjects,1);
    for i=1:numberOfObjects
        distanceD(i)=myModel.(['cluster' num2str(i)]).Parameters(4);
    end
    % filter clusters by distance D
    badDetections=0;
    clusters=[];
    for i=1:numberOfObjects
        if abs(distanceD(i))>2600
            badDetections=badDetections+1;
        else
            clusters=[clusters i];
        end
    end
    numberOfObjects=numberOfObjects-badDetections;
    if plotFlag
        figure,
            myLegends={};
            for i=1:numberOfObjects+badDetections
                rows=myrows.(['cluster' num2str(i)]);
    %             myRows.(['cluster' num2str(i)])=rows;
                tempPC=pointCloud(pcSingleType.Location(rows,:));
            %     charArray=dec2bin(i,3);
            %     color=logical(charArray)*255;
            %     tempPC=pcPaint(tempPC,color);
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
                num2str(frameID) ': Clusters ' num2str(clusters)])
    end
end


if plotFlag
    figure,
        pcshow(pcwoutGround)
        hold on
        dibujarsistemaref(eye(4),'m',250,2,10,'w');
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title (['pc wout ground sessionID/frameID ' num2str(sessionID) '/' num2str(frameID)])

end

end

