function boxOutput = extractBoxByBoxID(boxesVector,boxID)
%EXTRACTBOXBYBOXID Extracts a box from a boxesVector by using boxID as 
% reference
%   Detailed explanation goes here


N=length(boxesVector);
boxOutput=detectedBox(0,0,0,0,eye(4),0,0);%initialize output
for i=1:N
    if boxesVector(i).id==boxID
        boxOutput= boxesVector(i);
        break
    end
end

end
