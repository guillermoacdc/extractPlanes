function eD_m = computeDetectionErrorMatrix(myBoxes,...
    gtBoxes,tao_size, tao_translation)
%COMPUTEDETECTIONERRORMATRIX Compute detection error for all pairs of
%estimated and gt box. The result in form of a matrix with size (Neb,Ngt). 
% Where Neb is the number of estimated boxes and Ngt is the number of gt boxes
%   Detailed explanation goes here

Neb=length(myBoxes);
Ngtb=length(gtBoxes);%modified in objects version
eD_m=ones(Neb,Ngtb);

for i=1:Ngtb
    gtBox=gtBoxes(i);
    gtFeatureDetection=box2FeatureDetection(gtBox);
    for j=1:Neb
        myBox=myBoxes(j);
        estimatedFeatureDetection=box2FeatureDetection(myBox);
        eD=compute_eDetection(estimatedFeatureDetection,...
            gtFeatureDetection,tao_size, tao_translation);%boxID, gtBox, detectedPlane,dataSetPath,tao
        eD_m(j,i)=eD;
    end
end

end

