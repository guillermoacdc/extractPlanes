function [frames] = getTargetFramesFromScene(scene)
%GETTARGETFRAMESFROMSCENE Summary of this function goes here
%   Detailed explanation goes here
switch(scene)
   case 1 
        frames=[7 8];
   case 2
%         frames=[30 31];
        frames=[80 : 81];
   case 3 
        % % frames=[49 63];
        frames=[49 50];
   case 4 
%        frames=[2: 14];
        frames=[9 10];        
   case 5 
        frames=[24 25];
   case 6
      frames=[66 67];
   case 7
      frames=[17 18];      
   case 10 
      frames=[16 17];
   case 15
      frames=[103 104];
   case 18
      frames=[25 26];      
   case 32 
      frames=[24 25];      
   case 12 
        frames=[3 4];
   case 21
      frames=[31 32];
   case 51 
      frames=[29 30];      
   otherwise
      frames=[7 8];
end

end