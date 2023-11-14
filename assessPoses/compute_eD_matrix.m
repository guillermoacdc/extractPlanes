function eD_m=compute_eD_matrix(myBoxes, gtBoxes,tao)
% COMPUTE_ED_MATRIX compute error of detection in matrix form
Neb=length(myBoxes);
Ngtb=length(gtBoxes);%modified in objects version
eD_m=ones(Neb,Ngtb);

for i=1:Ngtb
    gtBox=gtBoxes(i);
    gtFeatureVector=convertBox2FeatureVector(gtBox);
    for j=1:Neb
        myBox=myBoxes(j);
        myFeatureVector=convertBox2FeatureVector(myBox);
        eD=compute_eD(myFeatureVector, gtFeatureVector,tao);%boxID, gtBox, detectedPlane,dataSetPath,tao
        eD_m(j,i)=eD;
    end
end


