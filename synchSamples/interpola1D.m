function [xout] = interpola1D(x, ii, ie)
%INTERPOLA1D Summary of this function goes here
%   Detailed explanation goes here
% x is a one dimension vector
% ii is the first index in the a batch of zeros
% ie is the last index in the batch of zeros
% xout is a interpolated version of x
    sizei=ie-ii+1;
    xout=x;
    if ii==1
        ii=2;%to avoid negative values in the index, For scene 1 the first sample was 0
        xout(ii-1:ie+1)=linspace(x(ii-1), x(ie+1), sizei+1);
    else
        if (ie+1)>=length(x)%to avoid indexes that override the length of x in samples that finishes with NaN
            xout(ii-1:end)=xout(ii-1);
        else
            xout(ii-1:ie+1)=linspace(x(ii-1), x(ie+1), sizei+2);
        end
    end    
end

