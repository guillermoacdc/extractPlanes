function output_struct = obj2struct(obj)
% Converts obj into a struct by examining the public properties of obj. It 
% copies the property and its value to 
% output_struct. 
% Addition: manage vector of objects
% Source: https://stackoverflow.com/questions/35736917/convert-matlab-objects-to-struct

if ~isempty(obj)
    [windowsFlag, oldfs, newfs]=computeWindowsFlag;
    properties = fieldnames(obj); % works on structs & classes (public properties)
    for i = 1:length(properties)
        val = obj.(properties{i});
        if ~isstruct(val) && ~isobject(val)
            if i==12 & windowsFlag & ~isempty(val) %manage of path value
                val = replace(val,oldfs, newfs);% to avoid escape character errors in decoding
            end
            output_struct.(properties{i}) = val; 
                    
        else
            if ~isvector(val)
                temp = obj2struct(val);
                if ~isempty(temp)
                    output_struct.(properties{i}) = temp;
                end
            else
                Ne=length(val);
    %             initiate empty struct with fields of class plane
    %             objTemp=plane(0,0,0,zeros(1,7),'',0);
    %             output_struct=obj2struct(objTemp);
                output_struct.(properties{i})=[];
                for j=1:Ne
                    output_struct.(properties{i})=[output_struct.(properties{i}) obj2struct(val(j))];
                end
            end
    
        end
    end
else
    output_struct=[];
end


end





