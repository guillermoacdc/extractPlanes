function qcase=computeCaseAdjustemtPose(er, globalPlanes, indexes)
% assing and id for the perpendicular plane in globalPlanes(indexes(2)).
% The id can be
% 1. for q located in the positive direction of ztop
% 2. for q located in the positive direction of xtop
% 3. for q located in the negative direction of ztop
% 4. for q located in the negative direction of xtop
th_angle=18;%update passing this variable as input argument
if er<th_angle
    qcase=1;
else
    if er>=180-th_angle
        qcase=3;
    else
        if globalPlanes(indexes(2)).D>globalPlanes(indexes(1)).D
            qcase=2;
        else
            qcase=4;
        end
    end
end

end