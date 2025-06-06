function output_struct = obj2struct_vector_proto(obj)
% Converts obj into a struct by examining the public properties of obj. It 
% copies the property and its value to 
% output_struct. 
% Addition: manage vector of objects
% Source: https://stackoverflow.com/questions/35736917/convert-matlab-objects-to-struct

properties = fieldnames(obj); % works on structs & classes (public properties)
% properties(12)=[];%forget property pathPoints to avoid errors during json decoding
Ne=size(obj,2);
if Ne~=0
    Np=length(properties);
    
    windowsFlag=false;
    old=filesep;
    if old=='\'
        windowsFlag=true;
    end
    
    
    if windowsFlag
        new=[old old];
    end
    
    for k=1:Ne
        for i = 1:Np
            val = obj(k).(properties{i});
            if i==12 & windowsFlag %manage of path value
                val = replace(val,old, new);
            end
            output_struct(k).(properties{i}) = val; 
        end
    end
else
    output_struct=[];
end

end





