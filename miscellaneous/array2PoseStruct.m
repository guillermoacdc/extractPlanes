function [structRepos] = array2PoseStruct(initialPoseRepos)
%ARRAY2POSESTRUCT Summary of this function goes here
%   Detailed explanation goes here
N=size(initialPoseRepos,1);%assumption:it is a even value
k=1;
for i=1:2:N
    structRepos{k}=convertPose2Struct(initialPoseRepos(i,:), initialPoseRepos(i+1,:));
    k=k+1;
end

end

