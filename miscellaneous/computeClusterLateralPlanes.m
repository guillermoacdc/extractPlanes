function clusterDescriptor=computeClusterLateralPlanes(xyz, inliersTopPlane, epsilon, ...
    minpts, groundNormal, th_distance, th_distance2, myRows_lateralPlanes, plotFlag)
%COMPUTECLUSTERLATERALPLANES Summary of this function goes here
%   Detailed explanation goes here

% for lateral planes we delete the top side of each cluster
    xyz(inliersTopPlane,:)=[];
    pcSingleType=pointCloud(xyz);
% form the descriptor to cluster    
    cosAlpha=computeCosAlpha(pcSingleType,groundNormal);
    X=[pcSingleType.Location(:,1), pcSingleType.Location(:,2), ...
    pcSingleType.Location(:,3), cosAlpha];
% cluster
%     Npoints=pcSingleType.Count;
%     minpts=int32(0.04*Npoints);
    idx = dbscan(X,epsilon,minpts);
% compute number of clusters
numberOfObjects=max(idx);

    %% fit clusterDescriptor.ID with plane model
    k=1;
    for i=1:numberOfObjects
        rows=find(idx==i);
        myRows_currentCluster=myRows_lateralPlanes(rows);
        myrows.(['cluster' num2str(k)])=rows;
        pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
        [planeModel_temp, inlierIndicesCluster, outlierIndicesCluster] =pcfitplane(pc_i,th_distance);
%         ----*
        clusterDescriptor.('rawIndex'){k}=myRows_currentCluster(inlierIndicesCluster);
        clusterDescriptor.('planeModel'){k}=planeModel_temp;
        k=k+1;
        if length(outlierIndicesCluster)>minpts/2
            rows=rows(outlierIndicesCluster);
            myRows_lateralPlanes2=myRows_currentCluster(outlierIndicesCluster);
            myrows.(['cluster' num2str(k)])=rows;
            pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
            pcSingleType.Location(rows,3)]);
            [planeModel_temp, inlierIndicesCluster] =pcfitplane(pc_i,th_distance);
            clusterDescriptor.('rawIndex'){k}=myRows_lateralPlanes2(inlierIndicesCluster);
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
            title ([ num2str(numberOfObjects) ' objects in current frame '...
                '; clusterDescriptor.ID ' num2str(clusterDescriptor.ID)])
    end

end

