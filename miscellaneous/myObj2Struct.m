function output_struct = myObj2Struct(obj)
%MYOBJ2STRUCT Summary of this function goes here
%   Detailed explanation goes here
if isvector(obj.values)
    output_struct=obj2struct_vector(obj);
else
    output_struct=obj2struct(obj);
end
    

end

