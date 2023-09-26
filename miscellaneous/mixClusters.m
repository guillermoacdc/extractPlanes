function clusterDescriptor=mixClusters(clusterTopPlanesDescriptor, clusterLateralPlanesDescriptor, clusterDescriptor)
%MIXCLUSTERS Summary of this function goes here
%   Detailed explanation goes here

Ntop=length(clusterTopPlanesDescriptor.ID);
Nlateral=length(clusterLateralPlanesDescriptor.ID);

for i=1:Ntop
    localID=clusterTopPlanesDescriptor.ID(i);
    clusterDescriptor.rawIndex{i}=clusterTopPlanesDescriptor.rawIndex{localID};
    clusterDescriptor.planeModel{i}=clusterTopPlanesDescriptor.planeModel{localID};
    clusterDescriptor.ID(i)=i;
end


for i=1:Nlateral
    localID=clusterLateralPlanesDescriptor.ID(i);
    clusterDescriptor.rawIndex{Ntop+i}=clusterLateralPlanesDescriptor.rawIndex{localID};
    clusterDescriptor.planeModel{Ntop+i}=clusterLateralPlanesDescriptor.planeModel{localID};
    clusterDescriptor.ID(Ntop+i)=Ntop+i;
end

end

