function pc_mm = myPCreadComposedPlane_soft(pathToPLY)
%MYPCREAD loads a composed point cloud from a path to a ply file. The output is in
%milimmeters
%   Assumptions: the ply file is saved in meters

N=length(pathToPLY);



if N>1% merged plane
    path_t=pathToPLY{1};
    pc_mm=myPCread(path_t);
    for i=2:N
        
        pc_t=myPCread(pathToPLY{i});
        pc_mm=pcmerge(pc_mm, pc_t,1);
    end

else
    pc_mm=myPCread(pathToPLY);
end

end

