function [output] = myANDvector(myvector)
%MYORVECTOR tf = myANDvector(X) computes a logic AND between elements in X.
%This first version just operates on one dimension
% Assumptions
% length(X)>1
% if Nr=1 then Nc>1, where [Nr Nc]=size(x)
% if Nc>1 then Nc=1, where [Nr Nc]=size(x)

output=true;
Nr=size(myvector,1);
Nv=size(myvector,2);
if Nr==1
    N=Nv;
else
    N=Nr;
end

i=1;
while i<=N 
    if ~myvector(i)
        output=false;
        return
    end
    i=i+1;
end

end

