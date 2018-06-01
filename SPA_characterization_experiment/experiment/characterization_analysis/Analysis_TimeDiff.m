clear
close all
clc
[fileName,path,fileIndx] = uigetfile;
File= fullfile(path, fileName);
disp('1. Load  file');
load(File);

answeredPercent=nbAnswered/nbTrials*100;
correctPercent=nbCorrectAnswers/nbAnswered*100;

disp('2. Sort data and compute parameters');

[allInstancesValsort,allInstanceValsortPos]=sort(forallInstance(:,1));

for idRow=1:size(forallInstance,1)
  forallInstanceSort(idRow,1)= forallInstance(allInstanceValsortPos(idRow),1);
  forallInstanceSort(idRow,2)= forallInstance(allInstanceValsortPos(idRow),2);
  forallInstanceSort(idRow,3)= forallInstance(allInstanceValsortPos(idRow),3);
  forallInstanceSort(idRow,4)= forallInstance(allInstanceValsortPos(idRow),4);
  forallInstanceSort(idRow,5)= forallInstance(allInstanceValsortPos(idRow),5);
  forallInstanceSort(idRow,6)= forallInstance(allInstanceValsortPos(idRow),6);
end

clear idx
[whenAnsweredValsort,whenAnsweredValsortPos]=sort(whenAnswered(:,1));

for idRow=1:size(whenAnswered,1)
  whenAnsweredSort(idRow,1)= whenAnswered(whenAnsweredValsortPos(idRow),1);
  whenAnsweredSort(idRow,2)= whenAnswered(whenAnsweredValsortPos(idRow),2);
  whenAnsweredSort(idRow,3)= whenAnswered(whenAnsweredValsortPos(idRow),3);
  whenAnsweredSort(idRow,4)= whenAnswered(whenAnsweredValsortPos(idRow),4);
end

minValTestedAnswered=min(whenAnsweredSort(:,1));
maxValTestedAnswered=max(whenAnsweredSort(:,1));
minReactTimeAnswered=min(whenAnsweredSort(:,4));
maxReactTimeAnswered=max(whenAnsweredSort(:,4));

clear idx
[whenNotAnsweredValsort,whenNotAnsweredValsortPos]=sort(whenNotAnswered(:,1));

for idRow=1:size(whenNotAnswered,1)
  whenNotAnsweredSort(idRow,1)= whenNotAnswered(whenNotAnsweredValsortPos(idRow),1);
  whenNotAnsweredSort(idRow,2)= whenNotAnswered(whenNotAnsweredValsortPos(idRow),2);
 
end

minValTestedNotAnswered=min(whenNotAnsweredSort(:,1));
maxValTestedNotAnswered=max(whenNotAnsweredSort(:,1));
minReactTimeNotAnswered=min(whenNotAnsweredSort(:,2));
maxReactTimeNotAnswered=max(whenNotAnsweredSort(:,2));

clear idx
[whenCorrectValsort,whenCorrectValsortPos]=sort(whenCorrect(:,1));

for idRow=1:size(whenCorrect,1)
  whenCorrectSort(idRow,1)= whenCorrect(whenCorrectValsortPos(idRow),1);
  whenCorrectSort(idRow,2)= whenCorrect(whenCorrectValsortPos(idRow),2);
  whenCorrectSort(idRow,3)= whenCorrect(whenCorrectValsortPos(idRow),3);
end

minValTestedCorrect=min(whenCorrectSort(:,1));
maxValTestedCorrect=max(whenCorrectSort(:,1));
minReactTimeCorrect=min(whenCorrectSort(:,3));
maxReactTimeCorrect=max(whenCorrectSort(:,3));

clear idx
[whenInCorrectValsort,whenInCorrectValsortPos]=sort(whenInCorrect(:,1));

for idRow=1:size(whenInCorrect,1)
  whenInCorrectSort(idRow,1)= whenInCorrect(whenInCorrectValsortPos(idRow),1);
  whenInCorrectSort(idRow,2)= whenInCorrect(whenInCorrectValsortPos(idRow),2);
  whenInCorrectSort(idRow,3)= whenInCorrect(whenInCorrectValsortPos(idRow),3);
end


minValTestedInCorrect=min(whenInCorrectSort(:,1));
maxValTestedInCorrect=max(whenInCorrectSort(:,1));
minReactTimeInCorrect=min(whenInCorrectSort(:,3));
maxReactTimeInCorrect=max(whenInCorrectSort(:,3));

ResPercent=[answeredPercent, correctPercent, nbTrials, NaN];
ResAns=[minValTestedAnswered,maxValTestedAnswered,minReactTimeAnswered,maxReactTimeAnswered];
ResNotAns=[minValTestedNotAnswered,maxValTestedNotAnswered, NaN, NaN];
ResCorr=[minValTestedCorrect,maxValTestedCorrect,minReactTimeCorrect,maxReactTimeCorrect];
ResInCorr=[minValTestedInCorrect,maxValTestedInCorrect,minReactTimeInCorrect,maxReactTimeInCorrect];

TotalRes=[ResPercent;ResAns;ResNotAns;ResCorr;ResInCorr];
headerCol_TotalRes={'minValTest', 'maxValTested','minReactionTime', 'maxReactionTime'};
headerRow_TotalRes={'AnsPerc-CorrPer-totalTrials';'Answered'; 'NotAnswered'; 'Correct'; 'Incorrect'};

disp('3. Save data');

fileName2save=strcat('Results_', fileName);
File2save= fullfile(path, fileName2save);

save(File2save, 'TotalRes','headerCol_TotalRes', 'headerRow_TotalRes','forallInstanceSort', ...
    'whenAnsweredSort','whenNotAnswered','whenCorrectSort', 'whenInCorrectSort');

disp('3.Completed');

TotalRes