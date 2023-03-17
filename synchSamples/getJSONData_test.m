clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scenes=[3	10	12	13	17	19	20	25	27	32	33	35	36	39	45	52	53	54	1	2	4	5	6	7	15	16	18	21];
% scenes=[1:54];
return
N=length(scenes);
% duration_v=zeros(N,1);
for i=1:N
    scene=scenes(i);
    [val] = getJSONData(rootPath,scene);
    min_str=extractBefore(val.length,':');
    seg_str=extractAfter(val.length,':');
    minutes=str2num(min_str);
    seg=str2num(seg_str);
    myduration=duration(0,minutes,seg);
    duration_v(i)=myduration;
end
[min(duration_v) max(duration_v)]

sum(duration_v)
    