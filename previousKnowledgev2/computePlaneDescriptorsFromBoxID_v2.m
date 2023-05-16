function [planeDescriptor] = computePlaneDescriptorsFromBoxID_v2(boxID,sessionID, dataSetPath, planeType)
%COMPUTEPLANEDESCRIPTORSFROMBOXID Computes descriptors of one of the set of planes
%that belong to the box with boxID. Those descriptors are refered to the
%coordinate frame q_b

% load lengths of the box
boxLengths=loadLengths_v2(dataSetPath,boxID);%IdBox,Heigth(mm),Width(mm),Depth(mm)
Height=boxLengths(2);
Width=boxLengths(3);
Depth=boxLengths(4);
T=eye(4);
switch (planeType)
    case 1
        %% 1 create descriptor for top plane
        tref=[0 0 0];
        A=0;
        B=0;
        C=1;
        D=0;
        planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        [L1,L2]=computeL1L2FromPK(boxLengths,0);
            
    case 2
        %% 2 create descriptor for front plane
        Rref=[0 -1 0; 0 0 1; -1 0 0];
        tref=[0 Width/2 -Height/2];
        A=0;
        B=1;
        C=0;
        D=-Width/2;
        planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,1);
        
    case 3
        %% 3 create descriptor for right plane
        Rref=[0 0 1; 0 1 0; -1 0 0];
        tref=[Depth/2 0 -Height/2];
        A=1;
        B=0;
        C=0;
        D=-Depth/2;
        planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,2);
        
    case 4
        %% 4 create descriptor for back plane
        Rref=[0 1 0; 0 0 -1; -1 0 0];
        tref=[0 -Width/2 -Height/2];
        A=0;
        B=-1;
        C=0;
        D=-Width/2;
        planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,1);
    case 5
        %% 5 create descriptor for left plane
        Rref=[0 0 -1; 0 -1 0; -1 0 0];
        tref=[-Depth/2 0 -Height/2];
        A=-1;
        B=0;
        C=0;
        D=-Depth/2;
        planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        [L1,L2]=computeL1L2FromPK(boxLengths,2);
        
end
planeDescriptor.tform=T;
planeDescriptor.L1=L1;
planeDescriptor.L2=L2;
planeDescriptor.L2toY=true;
planeDescriptor.idBox=boxID;

end

