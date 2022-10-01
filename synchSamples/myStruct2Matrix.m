function [pos_matrix] = myStruct2Matrix(pos_struct,markerIDs)
%MYSTRUCT2MATRIX Summary of this function goes here
%   Detailed explanation goes here

nmbMarkers=length(markerIDs);
nmbFrames=length(pos_struct.time);
pos_matrix=zeros(3,nmbMarkers,nmbFrames);

for k=1:nmbMarkers
    pos_matrix(1:3,k,:)=pos_struct.(['M00' num2str(markerIDs(k))])';
end
end

