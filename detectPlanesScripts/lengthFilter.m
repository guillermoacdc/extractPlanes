function [lengthFlag] = lengthFilter(myPlane,lengthBounds,th_lenght)
%LENGTHFILTER Summary of this function goes here
%   Detailed explanation goes here
% output %(0,1) for (non expected length, expected length)
L1min=lengthBounds(1);
L1max=lengthBounds(2);
L2min=lengthBounds(3);
L2max=lengthBounds(4);

lengthFlag=0;
L1_upper=L1max+th_lenght;
L1_lower=L1min-th_lenght;
L2_upper=L2max+th_lenght;
L2_lower=L2min-th_lenght;

if(L1_lower<0)
    L1_lower=0;
end

if(L2_lower<0)
    L2_lower=0;
end

if(myPlane.L1>L1_upper | myPlane.L1<L1_lower ...
        | myPlane.L2>L2_upper | myPlane.L2<L2_lower)
        lengthFlag=1;
end

end

