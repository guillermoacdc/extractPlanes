function [planeDescriptor] = computeSinglePlaneFromBox(myBox, sideID)
%COMPUTEPLANEDESCRIPTORSFROMBOXID Computes descriptors of one of the set of planes
%that belong to the box myBox. Those descriptors are refered to the
%coordinate frame q_b
% sidesVector codes -- updated to match with developments in box tracking
% 0 top plane
% 2 front plane
% 1 right plane
% 4 back plane
% 3 left plane
% parameters
sessionID=0;
frameID=0;
planeID=sideID;
pathPC=[];
Nmbinliers=[];
T=eye(4);
switch (sideID)
    case 0
        %% 0 create descriptor for top plane
        tref=[0 0 0];
        A=0;
        B=0;
        C=1;
        D=0;
        
                    
    case 2
        %% 2 create descriptor for front plane
%         Rref=[0 -1 0; 0 0 1; -1 0 0];
        Rref=rotx(-90);
        tref=[0 myBox.width/2 -myBox.height/2];
        A=0;
        B=1;
        C=0;
        D=-myBox.width/2;
%         planeDescriptor=plane(sessionID,frameID,planeID,[A B C D tref],pathPC,Nmbinliers);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        
    case 1
        %% 1 create descriptor for right plane
        Rref=roty(90);
%         Rref=[0 0 1; 0 1 0; -1 0 0];%roty(90)
        tref=[myBox.depth/2 0 -myBox.height/2];
        A=1;
        B=0;
        C=0;
        D=-myBox.depth/2;
%         planeDescriptor=plane(sessionID,frameID,planeID,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        
    case 4
        %% 4 create descriptor for back plane
%         Rref=[0 1 0; 0 0 -1; -1 0 0];%rotx(90)
        Rref=rotx(90);
        tref=[0 -myBox.width/2 -myBox.height/2];
        A=0;
        B=-1;
        C=0;
        D=-myBox.width/2;
%         planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
        
    case 3
        %% 3 create descriptor for left plane
        Rref=roty(-90);
%         Rref=[0 0 -1; 0 -1 0; -1 0 0];
        tref=[-myBox.depth/2 0 -myBox.height/2];
        A=-1;
        B=0;
        C=0;
        D=-myBox.depth/2;
%         planeDescriptor=plane(sessionID,0,planeType,[A B C D tref],[],[]);
        T(1:3,1:3)=Rref;
        T(1:3,4)=tref;
                
end
planeDescriptor=plane(sessionID,frameID,planeID,[A B C D tref],pathPC,Nmbinliers);
[L1,L2]=computeL1L2BySide(myBox,sideID);
planeDescriptor.tform=T;
planeDescriptor.L1=L1;
planeDescriptor.L2=L2;
% planeDescriptor.L2toY=true;
planeDescriptor.idBox=myBox.id;

end

