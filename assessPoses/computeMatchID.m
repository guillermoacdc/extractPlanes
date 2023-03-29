function matchID=computeMatchID(estimatedPose,theta,tao,pps)
%COMPUTEMATCHID computes matches based on comparisons btwn eADD and theta
%   The output is in the format [planeID, boxID]. For boxID=0, there are
%   not matches. 

    planeIDs=estimatedPose.IDObjects;
    eADD_m=estimatedPose.eADD.(['tao' num2str(tao)]);
    matchID=compare_eADDvsTheta(eADD_m,theta,planeIDs,pps);


end

