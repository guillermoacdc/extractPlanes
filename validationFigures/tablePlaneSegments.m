% id tipo banderaSigno fitness l1 l2
mydata=zeros(1,9);
for i=2:14
    id=planeSegmentDescriptor.fr25.values(i).getID;
    tipo=planeSegmentDescriptor.fr25.values(i).type;
    banderaSigno=planeSegmentDescriptor.fr25.values(i).antiparallelFlag;
    calidad=planeSegmentDescriptor.fr25.values(i).fitness;
    L1=planeSegmentDescriptor.fr25.values(i).L1;
    L2=planeSegmentDescriptor.fr25.values(i).L2;
    angle=planeSegmentDescriptor.fr25.values(i).angleBtwn_zc_unitNormal;
    distCamara=planeSegmentDescriptor.fr25.values(i).distanceToCamera;
    if isempty(tipo)
        tipo=NaN;
    end
    if isempty(angle)
        angle=NaN;
    end
    if isempty(distCamara)
        distCamara=NaN;
    end
    if isempty(calidad)
        calidad=NaN;
    end
    if isempty(L1)
        L1=NaN;
    end
    if isempty(L2)
        L2=NaN;
    end
    if isempty(banderaSigno)
        banderaSigno=NaN;
    end    
mydata(i-1,:)=[id tipo banderaSigno calidad L1 L2 angle distCamara];
end