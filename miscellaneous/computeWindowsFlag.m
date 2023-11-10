function [windowsFlag, oldfs, newfs]=computeWindowsFlag
%COMPUTEWINDOWSFLAG Summary of this function goes here
%   Detailed explanation goes here
 windowsFlag=false;
    oldfs=filesep;
    if oldfs=='\'
        windowsFlag=true;
    end
    
    
    if windowsFlag
        newfs=[oldfs oldfs];
    end
end

