function pps = getPPS_v0(scene)
%GETPPS Summary of this function goes here
%   Detailed explanation goes here

switch scene
    case 3
      pps=[13 17 16 18 19 20 10 9 5 6 7 8 1 2 3 4 14 15];
    case 4
      pps=[13 28 21 22 25 9 5 17 1];
    case 5
      pps=[13 17 16 18 19 20 22 23 14 15];
    case 6
      pps=[13 17 16 18 19 20 10 9 22 23 1 2 3 4 14 15 11 12];
    case 21
      pps=[13 11 12 17 19 19 9 20 10 16 23 22 1 2 3 4 14 15];
    case 51
      pps=[13 29 21 1 5 17 11];
    
   otherwise
       pps=[1];
end

end

