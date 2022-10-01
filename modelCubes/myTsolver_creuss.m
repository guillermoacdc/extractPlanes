function [Thm] = myTsolver_creuss(Tch,Tcm)
%MYTSOLVER_CREUSS Summary of this function goes here
%   Detailed explanation goes here

pch=Tch(1:3,4);
pcm=Tcm(1:3,4);

phm=pcm-pch;

Rch=Tch(1:3,1:3);
Rcm=Tcm(1:3,1:3);

Rhm=myRotationSolver(Rch,Rcm);

Thm=eye(4);
Thm(1:3,1:3)=Rhm;
Thm(1:3,4)=phm;

end

