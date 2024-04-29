function eTracking_m = computeTrackingErrorMatrix_veADD(myBoxes,...
    gtBoxes,tao, Npointsdp)
%COMPUTEDETECTIONERRORMATRIX Compute detection error for all pairs of
%estimated and gt box. The result in form of a matrix with size (Neb,Ngt). 
% Where Neb is the number of estimated boxes and Ngt is the number of gt boxes
%   Detailed explanation goes here

Neb=length(myBoxes);
Ngtb=length(gtBoxes);%modified in objects version
eTracking_m=ones(Neb,Ngtb);
plotFlag=false;
for i=1:Ngtb
    gtBox=gtBoxes(i);
    for j=1:Neb
        myBox=myBoxes(j);
        eADD=compareBoxes_v1(myBox,gtBox,tao,Npointsdp,plotFlag);
        eTracking_m(j,i)=eADD;
    end
end

end

