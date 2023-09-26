function [vectorData] = myConvertCellToVector(cellData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N=size(cellData,2);
vectorData=plane(0,0,0,zeros(1,7),[],0);
for i=1:N
    vectorData(i)=cellData{i};
end
end

