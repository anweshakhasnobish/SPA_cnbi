clear
close all
clc
[fileName,path,fileIndx] = uigetfile;
File= fullfile(path, fileName);
load(File);

nbTrials=run(1).TaskRunner.trialsPerRun;

nbAnswered=0;
nbNotAnswered=0;
nbCorrectAnswers=0;

for runInd=1: nbTrials
    reactionTime(runInd)=run(runInd).System.reactionTime;
    valueToTest(runInd)=run(runInd).System.valueToTest;
%     initialFrequency(runInd)=run(runInd).System.initialFrequency;
    outcome(runInd)=run(runInd).System.outcome;
    
    if run(runInd).System.hasAnswered==true
        nbAnswered=nbAnswered+1;
        reactionTimeAnswered(nbAnswered)=run(runInd).System.reactionTime;
        if run(runInd).System.outcome==true
            nbCorrectAnswers=nbCorrectAnswers+1;
        end
        
    else
        nbNotAnswered=nbNotAnswered+1;
    end
     
end    