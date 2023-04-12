function pc_mm = myPCread(pathToPLY)
%MYPCREAD loads a point cloud from a path to a ply file. The output is in
%milimmeters
%   Assumptions: the ply file is saved in meters

    pc_m = pcread(pathToPLY);%in [mt]; indices begin at 0
    xyz=pc_m.Location;
    xyz_mm=xyz*1000;
    pc_mm=pointCloud(xyz_mm);
end

