clc
clear all
close all

%% parameters
pt=0.99;%probabilitiy of a succesful detection; defined by user
k=2;%size of a minimal set required to define a shape candidate. 
n=1066;%size of the shape psi in the point cloud PC
N=2000000;%size of the point cloud PC; in number of points
d=2;%--octree's depth where the cell C is located; Points in cell=341.547

%% compute P(n)
Pn=(n/N)^k;%probability of detecting the shape psi in a single pass
Pn_local=n/(N*d*2^(k-1));

%% compute T
T=log(1-pt)/log(1-Pn)
T_local=log(1-pt)/log(1-Pn_local)


% x=T/T_local% expected 2.3337e+03

% log(1-pt)/151522829
% ans =
%   -3.0393e-08
% log(1-Pn)
% ans =
%   -2.8409e-07