function typeOfSession=computeTypeOfSession(sessionID)
%COMPUTETYPEOFSESSION Summary of this function goes here
%   Detailed explanation goes here

switch(sessionID)
    case {3,10,12,13,17,19,20,25,27,32,33,35,36,39,45,52,53,54}
        typeOfSession=1;
    case {1,2,4,5,6,7,8,9,11,14,23,31,37,40,42,43,46,51}
        typeOfSession=2;
    case {15,16,18,21,22,24,26,28,29,30,34,38,41,44,47,48,49,50}
        typeOfSession=3;

end

end

