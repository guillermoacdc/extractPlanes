function clusterDescriptor=computeClusterTopPlanes(xyz, inliersLateralPlane, epsilon, ...
    minpts, groundNormal, th_distance, th_distance2, myRows_topPlane, plotFlag)
%COMPUTECLUSTERTOPPLANES Summary of this function goes here
%   Detailed explanation goes here
% epsilon: threshold for a neighborhood search radius
% minpts:  minimum number of neighbors

% for top planes we delete the lateral planes of each cluster
    xyz(inliersLateralPlane,:)=[];
    pcSingleType=pointCloud(xyz);
% compute descriptors to cluster
    cosAlpha=computeCosAlpha(pcSingleType,groundNormal);
%     X=[pcSingleType.Location(:,1), pcSingleType.Location(:,2), ...
%     pcSingleType.Location(:,3), cosAlpha];
    X=[pcSingleType.Location(:,1), pcSingleType.Location(:,2), ...
    pcSingleType.Location(:,3)];
% cluster
    Npoints=pcSingleType.Count;
    minpts=int32(0.02*Npoints);
    idx = dbscan(X,epsilon,minpts/2);
% compute number of clusters
    numberOfObjects=max(idx);    

%compute distance of cluster to origin
    distance=zeros(numberOfObjects,1);

        for i=1:numberOfObjects
                rows=find(idx==i);
                clusterDescriptor.('rawIndex'){i}=myRows_topPlane(rows);
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
%                 myrows.(['cluster' num2str(i)])=rows;
                pc_i=pointCloud([pcSingleType.Location(rows,1),pcSingleType.Location(rows,2),...
                    pcSingleType.Location(rows,3)]);
                clusterDescriptor.('planeModel'){i} =pcfitplane(pc_i,th_distance);
        end

end

