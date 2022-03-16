function  passByreferenceTest(myPlanes)
%PASSBYREFERENCETEST Summary of this function goes here
%   Detailed explanation goes here

for i=1:5
    myPlanes{i}.secondPlaneID=-1;
end
end
% as stated in [1], this function operates as a pass by reference!!
%[1] https://www.mathworks.com/matlabcentral/answers/152-can-matlab-pass-by-reference