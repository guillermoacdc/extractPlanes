function [bufferCP] = updateBufferCP(planeA,planeB, bufferCP, maxComp)
%UPDATEBUFFERCP Updates the content of bufferCP. Avoids that composed
%planes are used as components of bufferCP
% * planeA is globalPlane(idx) 
% * planeB is localPlane
%   Detailed explanation goes here

% if maxComp==3
%     disp('stop from updateBufferCP')
% end

if planeA.idFrame==0
%     dont require add elements to buffer, just update values of components
%     bufferCP=updateIDofComponents(planeA.idFrame, planeA.idPlane, bufferCP, maxComp);
      bufferCP=updateIDofComponents_v2(planeA, bufferCP, maxComp);
else
    % plane A is a component of buffer?
    vector2D=extractIDsFromVector(bufferCP);
    idx=myFind2D([planeA.idFrame, planeA.idPlane], vector2D);
    if ~isempty(idx)
    % local update of buffer properties
        bufferCP(idx).composed_idFrame=0;
        bufferCP(idx).composed_idPlane=maxComp+1;
    else
    % add element to bufferCP
        planeA.composed_idFrame=0;
        planeA.composed_idPlane=maxComp+1;
        bufferCP=[bufferCP planeA];
    end
end

if planeB.idFrame==0
%     dont require add elements to buffer, just update values of components
%     bufferCP=updateIDofComponents(planeB.idFrame, planeB.idPlane, bufferCP, maxComp);
    bufferCP=updateIDofComponents_v2(planeB, bufferCP, maxComp);
else
    % plane B is a component of buffer?
    vector2D=extractIDsFromVector(bufferCP);
    idx=myFind2D([planeB.idFrame, planeB.idPlane], vector2D);
    if ~isempty(idx)
    % local update of buffer properties
        bufferCP(idx).composed_idFrame=0;
        bufferCP(idx).composed_idPlane=maxComp+1;
    else
    % add element to bufferCP
        planeB.composed_idFrame=0;
        planeB.composed_idPlane=maxComp+1;
        bufferCP=[bufferCP planeB];
    end

% stop if a component of bufferCP is composed
ids=extractIDsFromVector(bufferCP);
zeroElementIndex=find(ids(:,1)==0);
if ~isempty(zeroElementIndex)
    disp('stop from myPCreadComposedPlane- a component of bufferCP is composed')
end

end


end

