function getFitnessMetrics(planesVector, filePath)
% getFitnessMetrics saves a xls file with descriptors related with quality
% factor (or fitness factor)
% filePath="fitnessMetrics.xls";
% id
% id=extractIDsFromVector(localPlanes.values);
id=extractIDsFromVector(planesVector);
% quality
% fitness=extractFitnessFromVector(localPlanes.values);
fitness=extractFitnessFromVector(planesVector);

% [dco, theta_co, L1, L2, inliers]=extractMisc_FromVector(localPlanes.values);
[dco, theta_co, L1, L2, inliers]=extractMisc_FromVector(planesVector);
% [id, fitness, dco, theta_co, L1, L2, inliers]
dataToWrite=table(id, fitness, dco, theta_co, L1, L2, inliers);

writetable(dataToWrite,filePath,'WriteRowNames',true)