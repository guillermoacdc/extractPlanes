function plane = extractPlaneByBoxID(planesDescriptors_gt,boxID)
%EXTRACTPLANEBYBOXID Summary of this function goes here
%   Detailed explanation goes here


N=size(planesDescriptors_gt.fr0.acceptedPlanes,1);

for i=1:N
    if planesDescriptors_gt.fr0.values(i).idBox==boxID
        plane=planesDescriptors_gt.fr0.values(i);
        break
    end
end

end

