function newPath = computePathMergedPlane(path1,path2)
%COMPUTEPATHMERGEDPLANE Computes the a composed path from path1 and path2.
%The output is a cell with N components, with
%N=components(path1)+components(path2)
%   Detailed explanation goes here

if iscellstr(path1)
	N1=size(path1,2);
else
	N1=1;
end

if iscellstr(path2)
	N2=size(path2,2);
else
	N2=1;
end

k=1;
if N1>1
    for i=1:N1
        newPath{k}=path1{i};
        k=k+1;
    end
    
    if N2>1
        for i=1:N2
            newPath{k}=path2{i};
            k=k+1;
        end
    else
        newPath{k}=path2;    
    end
else
    newPath{k}=path1;
    k=k+1;
    if N2>1
        for i=1:N2
            newPath{k}=path2{i};
            k=k+1;
        end
    else
        newPath{k}=path2;    
    end
end

end

