function C = mySetDiff_2D(A,B)
%MYSETDIFF_2D returns the data in A that is not in B
%   Assumption: A and B are 2 dimensional with size Nx2
C=[];
N=size(A,1);
for i=1:N
    idx=[];
    target=A(i,:);
    idx=myFind2D(target,B);
    if isempty(idx)
        C=[C;target];
    end
end
end

