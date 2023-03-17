function [append] = computeAppendMocapFileName(scene)
%COMPUTEAPPEND Computes the number that is append to the mocap filename
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