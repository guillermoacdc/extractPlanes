function [wA,wB] = computeWeigths(fitnessA,fitnessB)
%COMPUTEWEIGTHS Summary of this function goes here
%   Detailed explanation goes here

if fitnessA==fitnessB
    wA=0.5;
    wB=0.5;
else
    if fitnessA>fitnessB
        if fitnessB==0
            wA=1;
            wB=0;
        else
            k=fitnessA/fitnessB;
            wB=1/(k+1);
            wA=k*wB;
        end
    else
        if fitnessA==0
            wB=1;
            wA=0;
        else
            k=fitnessB/fitnessA;
            wA=1/(k+1);
            wB=k*wA;            
        end
    
    end

end

