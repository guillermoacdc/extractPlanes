#!/bin/bash
rootName=%cd% 
for i in 2 3 4 5 6 7 8 9 20 21 22 23 24 25 26 27 28 29
do
   indexName=$( printf '%d' $i )
   directory_name="/frame"$indexName
   mkdir -p  outputPlanes"$directory_name"
   echo "frame $i folder created"
done
