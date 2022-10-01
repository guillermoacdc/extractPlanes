function [T] = assemblyTmatrix(Telements)
%ASSEMBLYTMATRIX Summary of this function goes here
%   Assembles a T matrix from a set of 16 elements or 14 elements in the
%   sequence
% Telements is a row vector with elements of T
% caseN is an integer with two options:
% case 16
% r11,r12,r13,px,r21,r22,r23,py,r31,r32,r33,pz, r41, r42, r43, r44
% case 12
% r11,r12,r13,px,r21,r22,r23,py,r31,r32,r33,pz, 0 0 0 1

    T=eye(4,4);
    T(1,1:4)=Telements(1,1:4);
    T(2,1:4)=Telements(1,5:8);
    T(3,1:4)=Telements(1,9:12);
end

