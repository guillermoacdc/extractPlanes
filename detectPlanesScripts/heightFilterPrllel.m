function [DFlag] = heightFilterPrllel(Dground,Dplane,Tolerance)
%HEIGHTFILTERPRLLEL Summary of this function goes here
%   Detailed explanation goes here

DFlag=1;
if abs(Dground-Dplane)>Tolerance
    DFlag=0;
end

