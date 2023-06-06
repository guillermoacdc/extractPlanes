function [output] = myFindDuplicates_2D(A)
%MYFINDDUPLICATES Find duplicates of a vector. Returns the duplicated value
%and the number of duplicates 
% Assumptions: A has dimension Nx2
A=sortrows(A);
Nrows=size(A,1);
output=[];
k=1;%index for the dynamic output
nD=1;%number of Duplicates
flag=false;% flag of sequence of repetitions

for i=1:Nrows-1
    if A(i,1)==A(i+1,1) & A(i,2)==A(i+1,2)
        value=A(i,:);
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

