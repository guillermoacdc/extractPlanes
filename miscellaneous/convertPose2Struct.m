function [structRepos] = convertPose2Struct(A,B)
%CONVERTPOSE2STRUCT Summary of this function goes here
%   A. First pose in array shape
% B. Second pose in array shape
structRepos.ref=B(1,2);
structRepos.boxID=B(1,1);
structRepos.firstPose=A(1,[3:end]);
structRepos.secondPose=B(1,[3:end]);
end

