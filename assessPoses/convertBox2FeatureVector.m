function featVector = convertBox2FeatureVector(boxObject)
%CONVERTBOX2FEATUREVECTOR Converts a box object into a feature vector with
%six features: height, width, depth, pos_x, pos_y, pos_z

% featVector=zeros(1,6);
% featVector(1)=boxObject.height;
% featVector(2)=boxObject.width;
% featVector(3)=boxObject.depth;
% featVector(4)=boxObject.tform(1,4);
% featVector(5)=boxObject.tform(2,4);
% featVector(6)=boxObject.tform(3,4);

featVector=zeros(1,3);
featVector(1)=boxObject.tform(1,4);
featVector(2)=boxObject.tform(2,4);
featVector(3)=boxObject.tform(3,4);


end

