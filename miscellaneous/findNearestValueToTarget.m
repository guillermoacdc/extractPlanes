function [idx] = findNearestValueToTarget(target,vector)
%FINDNEARESTVALUETOTARGET find the nearest value to the target. The search
%space is the input vector. This vector is 2d
%   Detailed explanation goes here
% source: https://www.mathworks.com/matlabcentral/answers/375710-find-nearest-value-to-specific-number

% offset=vector-target;
N=length(vector);
offset=zeros(1,N);
for i=1:N
    offset(i)=norm(target-vector(i,:));
end
[~,idx]=min(offset);
end