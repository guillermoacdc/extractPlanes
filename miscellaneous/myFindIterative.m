function idx=myFindIterative(group1, group2)
%MYFINDITERATIVE Perform an iterative search of each element from group2 in
%group 1. Returns the founded indexes
%   Detailed explanation goes here
idx=[];
N=length(group2);
for i=1:N
    targetValue=group2(i);
    index=find(group1==targetValue);
    if ~isempty(index)
        idx=[idx, index];
    end
end
end

