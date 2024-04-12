function featureDetection = box2FeatureDetection(myBox)
%BOX2FEATUREDETECTION Extracts features of object box. Just the features
%related with detection problem: size, position
%   Detailed explanation goes here
featureDetection.position(1)=myBox.tform(1,4);
featureDetection.position(2)=myBox.tform(2,4);
featureDetection.position(3)=myBox.tform(3,4);

featureDetection.size(1)=myBox.height;
featureDetection.size(2)=myBox.width;
featureDetection.size(3)=myBox.depth;
end

