function globalPlanes=assembleGlobalPlanes(tempData,index)
%ASSEMBLEGLOBALPLANES Summary of this function goes here
%   Detailed explanation goes here
Ni=length(index);
globalPlanes=[];
for i=1:Ni
    globalPlanes(i).type=tempData.type(index(i));
    globalPlanes(i).tform=tempData.tform(index(i));
    
    if ~isstruct(tempData.idFrame(index(i)))
        globalPlanes(i).idFrame=tempData.idFrame(index(i));
    else
        globalPlanes(i).idFrame=tempData.idFrame(index(i)).mwdata;
    end
    globalPlanes(i).idPlane=tempData.idPlane(index(i));
end

end

