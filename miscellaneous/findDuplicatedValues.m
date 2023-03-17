function [output] = findDuplicatedValues(A)
%FINDDUPLICATEDVALUES Find the indices of original and duplicate values in one array
% assumption: repetitions are adjacent
%   Detailed explanation goes here

% find first duplicated indexes
N=length(A);
k=1;
duplicated_indexes=[];
for i=1:N-1
    if(A(i)==A(i+1))
        duplicated_indexes(k)=i;
        k=k+1;
    end
end

if isempty(duplicated_indexes)
    output=[];
else
    % complement the finding with its adjacent index
    N=length(duplicated_indexes);
    k=1;
    output=zeros(1,2*N);
    for i=1:N
        output(k)=duplicated_indexes(i);
        output(k+1)=duplicated_indexes(i)+1;
        k=k+2;
    end        
end



end

