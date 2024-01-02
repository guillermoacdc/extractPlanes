function valueout=myValidateEmpty(valuein, valueIfEmpty)
% validate if the data is empty. If so, returns the valueIfEmpty

if isempty(valuein)
    valueout=valueIfEmpty;
else
    valueout=valuein;
end

end