function writeLogBasis(er, et, eL1, eL2, eADD, n_inliers, dc, boxID, evalPath, frame, scene)
% This function writes the base indicators in the assesment of pose

% save the current path
currentcd=pwd;
% go to evalpath 
cd (evalPath);
% create folder
folderName=['scene' num2str(scene)];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end

% return to saved path
cd (currentcd);

    fileName=['box' num2str(boxID) '.txt'];
    fid=fopen([evalPath  '\scene'  num2str(scene) '\'  fileName ],'a');
    fprintf(fid,'%d %f %f %f %f %f %d %f\n',frame, er, et, eADD, eL1, eL2, n_inliers, dc);
    fclose(fid);
end