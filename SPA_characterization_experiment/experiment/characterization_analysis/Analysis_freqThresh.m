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

[allInstancesValsort,allInstanceValsortPos]=sort(forallInstance(:,2));

for idx=1:size(forallInstance,1)
  forallInstanceSort(idx,1)= forallInstance(allInstanceValsortPos(idx),1);
  forallInstanceSort(idx,2)= forallInstance(allInstanceValsortPos(idx),2);
  forallInstanceSort(idx,3)= forallInstance(allInstanceValsortPos(idx),3);
  forallInstanceSort(idx,4)= forallInstance(allInstanceValsortPos(idx),4);
  forallInstanceSort(idx,5)= forallInstance(allInstanceValsortPos(idx),5);
end

clear idx
[whenAnsweredValsort,whenAnsweredValsortPos]=sort(whenAnswered(:,1));

for idx=1:size(whenAnswered,1)
  whenAnsweredSort(idx,1)= whenAnswered(whenAnsweredValsortPos(idx),1);
  whenAnsweredSort(idx,2)= whenAnswered(whenAnsweredValsortPos(idx),2);
  whenAnsweredSort(idx,3)= whenAnswered(whenAnsweredValsortPos(idx),3);
  
end

minValTestedAnswered=min(whenAnsweredSort(:,1));
maxValTestedAnswered=max(whenAnsweredSort(:,1));
minReactTimeAnswered=min(whenAnsweredSort(:,3));
maxReactTimeAnswered=max(whenAnsweredSort(:,3));

minValTestedNotAnswered=min(whenNotAnswered);
maxValTestedNotAnswered=max(whenNotAnswered);

clear idx
[whenCorrectValsort,whenCorrectValsortPos]=sort(whenCorrect(:,1));

for idx=1:size(whenCorrect,1)
  whenCorrectSort(idx,1)= whenCorrect(whenCorrectValsortPos(idx),1);
  whenCorrectSort(idx,2)= whenCorrect(whenCorrectValsortPos(idx),2);
  
end

minValTestedCorrect=min(whenCorrectSort(:,1));
maxValTestedCorrect=max(whenCorrectSort(:,1));
minReactTimeCorrect=min(whenCorrectSort(:,2));
maxReactTimeCorrect=max(whenCorrectSort(:,2));

clear idx
[whenInCorrectValsort,whenInCorrectValsortPos]=sort(whenInCorrect(:,1));

for idx=1:size(whenInCorrect,1)
  whenInCorrectSort(idx,1)= whenInCorrect(whenInCorrectValsortPos(idx),1);
  whenInCorrectSort(idx,2)= whenInCorrect(whenInCorrectValsortPos(idx),2);
end


minValTestedInCorrect=min(whenInCorrectSort(:,1));
maxValTestedInCorrect=max(whenInCorrectSort(:,1));
minReactTimeInCorrect=min(whenInCorrectSort(:,2));
maxReactTimeInCorrect=max(whenInCorrectSort(:,2));

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

disp('4. Completed')
TotalRes