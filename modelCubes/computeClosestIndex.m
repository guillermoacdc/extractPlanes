function [closestIndex]=computeClosestIndex(V,Nvector)
% based on https://www.mathworks.com/matlabcentral/answers/152301-find-closest-value-in-array
% Description
% computes the closest value in a vector “Nvector” for each element of “V”

A = repmat(V,[1 length(Nvector)])';
[minValue,closestIndex] = min(abs(A-Nvector));

end