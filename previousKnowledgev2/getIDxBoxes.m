function idxBoxes = getIDxBoxes(rootPath,scene,boxesID)
%GETIDXBOXES Computes the index of boxes (idxBoxes) in the pps of an specific scene.
%When boxID is different than empty, the idxBoxes is not sequential
%   input
%       rootPath: path to data
%       scene: number of scene
%       boxesID: identifiers of target boxes in the scene; assumption: all
%       identifiers exist in the scene
% output
%       idxBoxes: index of boxes in the physical packing sequence

if nargin==2
    boxesID=[];
end
% compute idxBoxes based on the value of boxes ID
if isempty(boxesID)
    pps=getPPS(rootPath,scene);
    idxBoxes=1:length(pps);
else
    pps=getPPS(rootPath,scene);
    for i=1:length(boxesID)
        idxBoxes(i)=find(pps==boxesID(i));
    end
end

end

