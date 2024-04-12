function eD = compute_eDetection(estimatedFeatureDetection,...
            gtFeatureDetection,tao_size, tao_translation)
%COMPUTE_EDETECTION Computes the error detection between an estimated and a
%gt feature vector
%   Detailed explanation goes here
Nfeat=3;
et=ones(1,Nfeat);
esize=ones(1,Nfeat);
for i=1:Nfeat
    et(i)=abs(gtFeatureDetection.position(i)-estimatedFeatureDetection.position(i))>tao_translation;
    esize(i)=abs(gtFeatureDetection.size(i)-estimatedFeatureDetection.size(i))>tao_size;
end
eD=0.5*mean(et)+0.5*mean(esize);
end

