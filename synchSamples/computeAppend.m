function [append] = computeAppend(scene)
%COMPUTEAPPEND Summary of this function goes here
%   Detailed explanation goes here

switch scene
   case 1
      append=4;
   case 44
      append=3;
   case {4, 8, 12,  13, 16, 18, 21, 24, 25, 28, 48}
      append=2;
    
   otherwise
      append=1;
end


end

