function [lengthFlag] = lengthFilter(myPlane,lengthBounds,th_lenght)
%LENGTHFILTER Summary of this function goes here
%   Detailed explanation goes here
% output %(0,1) for (non expected length, expected length)
L1min=lengthBounds(1);
L1max=lengthBounds(2);
L2min=lengthBounds(3);
L2max=lengthBounds(4);

lengthFlag=1;
if(myPlane.L1*100>L1max+th_lenght | myPlane.L1*100<L1min-th_lenght ...
        | myPlane.L2*100>L2max+th_lenght | myPlane.L2*100<L2min-th_lenght)
        lengthFlag=0;
end

end

