function FN = computeFN_vboxDetection(matchID, visibleBoxByFrame)
%COMPUTEFN_VBOXDETECTION Computes false negative vector comparing detected
%IDs vs visible box IDs by frame
%   Detailed explanation goes here
gtDetectedID_raw=matchID(:,2);
gtIDOR=myORvector(gtDetectedID_raw);

if gtIDOR
    idxgtDetectedID=find(gtDetectedID_raw);
    gtDetectedID=gtDetectedID_raw(idxgtDetectedID);
    FN=setdiff(visibleBoxByFrame,gtDetectedID);
else
    FN=visibleBoxByFrame;
end

end

