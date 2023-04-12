function [couple1, couple2, couple3] = classifyCouples(couples,myPlanes)
%CLASSIFYCOUPLES Classify couples of planes in the categories:
% couple1: {xyPlane, xzPlane}
% couple2: {zyPlane, xzPlane}
% couple3: {xyPlane, zyPlane}
%   Detailed explanation goes here
% input - couples: a vector with indexes and size Nx4; colums 1 to 2
% contain the identifier of target plane, columns 3 to 4 contain the
% identifier of the second plane
% input - myPlanes: cell of objects with descreiptors of all available planes

couple1=[];
couple2=[];
couple3=[];

for i=1:size(couples,1)
    targetP=couples(i,1:2);
    secondP=couples(i,3:4);
    b1=myPlanes.(['fr' num2str(targetP(1))]).values(targetP(2)).type;
    %convert to boolean
    b1=logical(b1);
    b2=myPlanes.(['fr' num2str(secondP(1))]).values(secondP(2)).type;
    %convert to boolean
    b2=logical(b2);
    b3=myPlanes.(['fr' num2str(targetP(1))]).values(targetP(2)).planeTilt;
    b4=myPlanes.(['fr' num2str(secondP(1))]).values(secondP(2)).planeTilt;

    if b1 & b2%is couple 3?
        couple3=[couple3; couples(i,:)];
    else
        if  (~b1)*b2*(~b4) | b1*(~b3)*(~b2) %is couple 2?
            couple2=[couple2; couples(i,:)];
        else
            if (~b1)*b2*b4 | b1*b3*(~b2) %is couple 1?
                couple1=[couple1; couples(i,:)];
            end
        end
    end
end

end

