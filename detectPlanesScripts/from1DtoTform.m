function T = from1DtoTform(cameraPose)
%FROM1DTOTTFORM Transform a 1-D vector with size 1x17 to a transformation
%matrix with size 4x4
%   Detailed explanation goes here
T=eye(4);
T(1,1:3)=cameraPose(2:4);
T(2,1:3)=cameraPose(6:8);
T(3,1:3)=cameraPose(10:12);
T(1:3,4)=[cameraPose(5) cameraPose(9) cameraPose(13)]';%position

end

