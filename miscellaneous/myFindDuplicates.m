function [output] = myFindDuplicates(A)
%MYFINDDUPLICATES Find duplicates of a vector. Returns the duplicated value
%and the number of duplicates 
% Assumptions: A has a single dimension, ejm 1xN or Nx1
A=sort(A);
N=length(A);
output=[];
k=1;%index for the dynamic output
nD=1;%number of Duplicates
flag=false;% flag of sequence of repetitions

for i=1:N-1
    if A(i)==A(i+1)
        value=A(i);
        nD=nD+1;
        flag=true;
    else
        if flag
            output(k,:)=[value nD];
            k=k+1;
            flag=false;
            nD=1;
        end
    end

end

if flag
    output(k,:)=[value nD];
    k=k+1;
    flag=false;
    nD=1;
end

end

