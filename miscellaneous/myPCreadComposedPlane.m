function pc_mm = myPCreadComposedPlane(pathToPLY, idFrame, idPlane, buffer)
%MYPCREAD loads a composed point cloud from a path to a ply file. The output is in
%milimmeters
%   Assumptions: the ply file is saved in meters

if idFrame==0% merged plane
    idComponents=getComponentsMergedPlanes(idFrame, idPlane, buffer);
    N=size(idComponents,1);
    indext=extractIndexFromIDs(buffer,idComponents(1,1), idComponents(1,2));
    pc_mm=myPCread(buffer(indext).pathPoints);
    if N>1
        for i=2:N
            indext=extractIndexFromIDs(buffer,idComponents(i,1), idComponents(i,2));
            pc_t=myPCread(buffer(indext).pathPoints);
            pc_mm=pcmerge(pc_mm, pc_t,1);
        end
    end
else
    pc_mm=myPCread(pathToPLY);
end

end

