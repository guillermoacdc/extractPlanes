function [xout firstNonZeroIndex] = interpolateMocap(x)
%INTERPOLATEMOCAP Summary of this function goes here
% x is a vector of size (nb of frames, 1) with NaN at some elements
% xout is the interpolated version of x. interpolation is performed at
% batches of NaN and using a linear interpolation. 
% Dimensions
% xout is a column vector
% x is a column vector

% 1 convert NaN to 0
    x(isnan(x))=0;
% 2 compute transitions between batches of zeros
    transitions = diff([0; x == 0;  0]); %find where the array goes from non-zero to zero and vice versa
    [r_init ]=find(transitions ==1);%begin of the zeros batch. 
    [r_stop ]=find(transitions ==-1);%end of the zeros batch
% 3 apply linear interpolation for each batch of zeros
    for i=1:length(r_init)
        x=interpola1D(x, r_init(i), r_stop(i)-1);
    end
    xout=x;
    if r_init(1)>1%registro sin valores NaN en el inicio de la secuencia
        firstNonZeroIndex=1;
    else%primer valor diferente de cero para registros con valores NaN al inicio de la sec
        firstNonZeroIndex=r_stop(1)+1;
    end
end

