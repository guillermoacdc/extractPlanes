function [Aout, duplicatedIndex] = myUnique2D(Ain)
%MYUNIQUE2D Returns a 2D vector witout repeated couples. The returned
%vector is sorted in ascendent order
% Assumption: The input has size Nx2; the couples are elements of the same
% row
%   Detailed explanation goes here
A=sortrows(Ain);
N=size(A,1);
duplicatedIndex=[];
Aout=[];
for i=1:N-1
    if A(i,1)==A(i+1,1) & A(i,2)==A(i+1,2)
        duplicatedIndex=[duplicatedIndex, i];
    end
end
Aout=A;
% Nduplicated=length(duplicatedIndex);
% for i=1:Nduplicated
%     Aout(duplicatedIndex(i),:)=[];
% end
Aout(duplicatedIndex,:)=[];
end

