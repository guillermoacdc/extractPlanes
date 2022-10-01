function [fid] = myWriteToFile_v2( T, tstamp,  fid)
%MYWRITETOFILE Summary of this function goes here
%   Detailed explanation goes here
  fprintf( fid, '%i,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',tstamp,...
      T );
end

