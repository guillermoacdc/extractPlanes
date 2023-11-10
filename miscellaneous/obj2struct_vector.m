function output_struct = obj2struct_vector(obj)
% Converts obj into a struct by examining the public properties of obj. It 
% copies the property and its value to 
% output_struct. 
% Addition: manage vector of objects
% Source: https://stackoverflow.com/questions/35736917/convert-matlab-objects-to-struct
Ne=length(obj.values);
output_struct=[];%probar vector fila para evitar versiones diferentes a las creadas
for i=1:Ne
    output_struct=[output_struct obj2struct(obj.values(i))];
end
end





