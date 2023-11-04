function myClearSecondAndThirdPlaneID(globalPlanes)

Np=length(globalPlanes);
for i=1:Np
    globalPlanes(i).secondPlaneID=[];
    globalPlanes(i).thirdPlaneID=[];
end

end