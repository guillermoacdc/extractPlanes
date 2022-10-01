function [closestIndex]=computeClosestIndex(V,N)
% based on https://www.mathworks.com/matlabcentral/answers/152301-find-closest-value-in-array
% Description
% computes the closest value in a vector “N” for each element of “V”

A = repmat(V,[1 length(N)])';
[minValue,closestIndex] = min(abs(A-N));

end