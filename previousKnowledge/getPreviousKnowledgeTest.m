clc
close all
clear

rootPath="C:\lib\boxTrackinPCs\";
physicalPackingSequence=[13 29 21 1 5 17 11];
lengthPreviousKnowldege=getPreviousKnowledge(rootPath, ...
    physicalPackingSequence)