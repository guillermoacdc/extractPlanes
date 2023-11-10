function output_struct = obj2struct_vector_v2(obj)
% Converts obj into a struct by examining the public properties of obj. It 
% copies the property and its value to 
% output_struct. 
% Addition: manage vector of objects
% Source: https://stackoverflow.com/questions/35736917/convert-matlab-objects-to-struct
[windowsFlag, oldfs, newfs]=computeWindowsFlag();
properties = fieldnames(obj); % works on structs & classes (public properties)
for i = 1:length(properties)
    val = obj.(properties{i});
    if ~isstruct(val) && ~isobject(val)
        if i==12 & windowsFlag %manage of path value
                val = replace(val,oldfs, newfs);% to avoid escape character errors in decoding
        end
        output_struct.(properties{i}) = val; 
    else
        if isa(val, 'serial') || isa(val, 'visa') || isa(val, 'tcpip')
            % don't convert communication objects
            continue
        end
        temp = obj2struct(val);
        if ~isempty(temp)
            output_struct.(properties{i}) = temp;
        end
    end
end
end





