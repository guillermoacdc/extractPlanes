function [Tout] = unassemblyTMatrix(planeDescriptor)
%UNASSEMBLYTMATRIX Summary of this function goes here
%   Detailed explanation goes here
Tout=zeros(1,13);
Tout(1)=planeDescriptor.idBox;
Tout(2:5)=planeDescriptor.tform(1,1:4);
Tout(6:9)=planeDescriptor.tform(2,1:4);
Tout(10:13)=planeDescriptor.tform(3,1:4);
%     T=eye(4,4);
%     T(1,1:4)=Telements(1,1:4);
%     T(2,1:4)=Telements(1,5:8);
%     T(3,1:4)=Telements(1,9:12);
end

