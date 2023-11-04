function er = computeRotationError(R1,R2)
%COMPUTEROTATIONERROR Summary of this function goes here
%   Detailed explanation goes here
er=acos((trace(R1'*R2)-1)/2)*180/pi;
er=real(er);%indagate what about the imaginary part
end

