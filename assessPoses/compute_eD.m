function eD=compute_eD(myFeatureVector, gtFeatureVector,tao)
%COMPUTE_ED Computes detection error
%   Detailed explanation goes here

N=length(myFeatureVector);
eD_vector=ones(N,1);
for i=1:N
    eD_vector(i)=abs(gtFeatureVector(i)-myFeatureVector(i))>tao;
end
eD=sum(eD_vector)/N;
end

