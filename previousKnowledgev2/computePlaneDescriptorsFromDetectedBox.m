function [planeDescriptor] = computePlaneDescriptorsFromDetectedBox(boxObject,sessionID, dataSetPath, planeSide)
%computePlaneDescriptorsFromDetectedBox Computes descriptors of each one of the 
% planes that compose a detected box. Thos descriptors differ wrt the
% scanned plane because they were compensated and refinated in length. 
% Those descriptors are refered to the coordinate system qh
% planeSide:
% 0 top plane
% 1 right plane
% 2 front plane
% 3 left plane
% 4 back plane

% load lengths of the box
Height=boxObject.height;
Width=boxObject.width;
Depth=boxObject.depth;
boxID=boxObject.id;
boxLengths=[boxID, Height, Width, Depth];
T=eye(4);
switch (planeSide)
    case 0
        %%  create descriptor for top plane
        tref=[0 0 0];
        A=0;
        B=1;
        C=0;
        D=0;
        planeDescriptor=plane(sessionID,0,planeSide,[A B C D tref],[],[]);
        [L1,L2]=computeL1L2FromPK(boxLengths,0);
    
    case 1
        %%  create descriptor for right plane
        Rref=[1 0 0; 0 0 -1; 0 1 0];
        tref=[0 -Height/2 Depth/2];
        A=0;
        B=0;
        C=1;
        D=-Depth/2;
        planeDescriptor=plane(sessionID,0,planeSide,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,2);            
    
    case 2
        %%  create descriptor for front plane
        Rref=[0 1 0; 0 0 -1; -1 0 0];
        tref=[Width/2 -Height/2 0];
        A=1;
        B=0;
        C=0;
        D=-Width/2;
        planeDescriptor=plane(sessionID,0,planeSide,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,1);
        
    case 3
        %%  create descriptor for left plane
        Rref=[-1 0 0; 0 0 -1; 0 -1 0];
        tref=[0 -Height/2 -Depth/2];
        A=0;
        B=0;
        C=-1;
        D=-Depth/2;
        planeDescriptor=plane(sessionID,0,planeSide,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,2);    
        
    case 4
        %%  create descriptor for back plane
        Rref=[0 -1 0; 0 0 -1; 1 0 0];
        tref=[-Width/2 -Height/2 0];
        A=-1;
        B=0;
        C=0;
        D=-Width/2;
        planeDescriptor=plane(sessionID,0,planeSide,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,1);
end
planeDescriptor.tform=T;
planeDescriptor.L1=L1;
planeDescriptor.L2=L2;
planeDescriptor.L2toY=true;
planeDescriptor.idBox=boxID;

end

