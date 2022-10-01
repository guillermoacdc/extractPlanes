function [offsetH, offsetMin] = computeOffsetSynch_raw(scene)
%COMPUTEOFFSETSYNCH_RAW Computes the offset between the device clock and
%mocap host system clock by each scene. 
%   Detailed explanation goes here

switch scene
    case {7,9,10,11}
        offsetH=-31;
        offsetMin=12;
    case 44
        offsetH=5;
        offsetMin=-18;
    otherwise
        offsetH=5;
        offsetMin=0;
end


end

