function output_struct = obj2struct(obj)
% Converts obj into a struct by examining the public properties of obj. If
% a property contains another object, this function recursively calls
% itself on that object. Else, it copies the property and its value to 
% output_struct. This function treats structs the same as objects.
%
% Note: This function skips over serial, visa and tcpip objects, which
% contain lots of information that is unnecessary (for us).
% Source: https://stackoverflow.com/questions/35736917/convert-matlab-objects-to-struct
properties = fieldnames(obj); % works on structs & classes (public properties)
properties(12)=[];%forget property pathPoints to avoid errors during json decoding
for i = 1:length(properties)

    val = obj.(properties{i});
    if ~isstruct(val) && ~isobject(val)
        output_struct.(properties{i}) = val; 
    else
%         if isa(val, 'serial') || isa(val, 'visa') || isa(val, 'tcpip')
%             % don't convert communication objects
%             continue
%         end
%         temp = obj2struct(val);
%         if ~isempty(temp)
%             output_struct.(properties{i}) = temp;
%         end
    end
end


