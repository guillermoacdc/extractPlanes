function [pos_interpolated] = rigidIterpoByChannel(markerID,pos_struct,refID, targetID,rootPath,scene)
%RIGIDITERPOBYCHANNEL Summary of this function goes here
%   Detailed explanation goes here

% convert from struct to matrix
pos_matrix= myStruct2Matrix(pos_struct,markerIDs);
N=size(pos_matrix,3);

% interpolate targetID
for i=1:N

end

end

