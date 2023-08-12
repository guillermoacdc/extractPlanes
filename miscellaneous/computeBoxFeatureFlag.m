function [highTextureFlag, highSizeFlag, newBoxFlag]=computeBoxFeatureFlag(boxID)
% This function computes three flags related with the boxes used in the
% dataset
% highTextureFlag
% highSizeFlag
% newBoxFlag

% texture flag
highTextureFlag=0;
if boxID > 20 & boxID <30 %[21:29]
    highTextureFlag=1;
end
% sizeFlag
highSizeFlag=0;
if (boxID > 12 & boxID <21)  | (boxID > 25 & boxID <31) %[13:20] or [26:30]
    highSizeFlag=1;
end
% newBoxFlag
newBoxFlag=0;
if boxID > 0 & boxID <21 %[1:20]
    newBoxFlag=1;
end

end