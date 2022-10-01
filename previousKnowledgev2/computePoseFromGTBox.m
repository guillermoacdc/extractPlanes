function [tform_out,modelParameters] = computePoseFromGTBox(tform,boxLength,planeType,angle)
%COMPUTEPOSEFROMGTBOX Summary of this function goes here
%   Detailed explanation goes here
% tform=assemblyTmatrix(planePose);
L1=boxLength(1);
L2=boxLength(2);
H=boxLength(3);
switch planeType
    case 0
            tform_out=tform;
            n=tform_out(1:3,3);%z axis
    case 1
        if angle>45
            ts3=[L1/2 0 -H/2];
            T=eye(4);
            T(1:3,4)=ts3';
            tform_out=tform*T;
            n=tform_out(1:3,1);%x axis
        else
            ts1=[-L1/2 0 -H/2];
            Rs1=rotz(180);
            T=eye(4);
            T(1:3,1:3)=Rs1;
            T(1:3,4)=ts1';
            tform_out=tform*T;
            n=-tform_out(1:3,1);%-x axis
        end



    case 2
        if angle<-45
            ts4=[0 L2/2 -H/2];
            T=eye(4);
            T(1:3,4)=ts4';
            tform_out=tform*T;
            n=tform_out(1:3,2);%y axis
        else
            ts2=[0 -L2/2 -H/2];
            Rs2=rotz(180);
            T=eye(4);
            T(1:3,1:3)=Rs2;
            T(1:3,4)=ts2';
            tform_out=tform*T;
            n=-tform_out(1:3,2);%-y axis
        end
end
            gc=tform_out(1:3,4);
            modelParameters=[n(1) n(2) n(3) gc(3) gc(1) gc(2) gc(3)];%A B C D geometricCenter in scene
% note. D parameter is not satisfied in perpendicular planes
end

