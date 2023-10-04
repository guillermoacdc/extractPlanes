function [NTP, NFP, NFN]=myCounter(cAssessment, pkflag)
%MYCOUNTER Summary of this function goes here
%   Detailed explanation goes here

if isempty(cAssessment.TPm)
    NTP=0;
else
    NTP=size(cAssessment.TPm,1);
end

if isempty(cAssessment.FPhl2)
    NFP=0;
else
    NFP=size(cAssessment.FPhl2,1);
end


if isempty(cAssessment.FNm)
    NFN=0;
else
    NFN=size(cAssessment.FNm,1);
end

if pkflag==0
    NFP=NFP+cAssessment.Nnap;
end

end

