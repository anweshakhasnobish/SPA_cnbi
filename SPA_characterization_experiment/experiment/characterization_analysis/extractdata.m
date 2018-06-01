clear
close all
clc
[fileName,path,fileIndx] = uigetfile;
File= fullfile(path, fileName);
disp('1. Load  file');
load(File);

nbTrialsSet=run(1).TaskRunner.trialsPerRun;
nbTrialsRan=size(run,2);

if nbTrialsSet==nbTrialsRan
    nbTrials=nbTrialsSet;
elseif nbTrialsRan<nbTrialsSet
    nbTrials=nbTrialsRan;
end
    

nbAnswered=0;
nbNotAnswered=0;
nbCorrectAnswers=0;
nbInCorrectAnswers=0;

fields=fieldnames(run);
Field2=run.(fields{2});
fields_Field2=fieldnames(Field2);
varNameEnd=cell2mat(fields_Field2(end));

requiredVarforTimeDiff='trueThreshold';

timeDiffVar=strcmp(varNameEnd,requiredVarforTimeDiff);

% if varNameEnd=='trueThreshold'
%     useVar='trueThreshold';
% elseif varNameEnd=='initialFrequency'
%     useVar='initialFrequency';
% end

% Field2.(fields_Field2{12})




disp('2. Extract Data');

for runInd=1: nbTrials
    
    valueToTestAllInstance(runInd)=run(runInd).System.valueToTest;
    valueTestedAllInstance(runInd)=run(runInd).System.stateMemory(end);
    initialFreqGivenAllInstance(runInd)=run(runInd).System.stateMemory(1);
    hasAnsweredAllInstance(runInd)=run(runInd).System.hasAnswered;
    outcomeAllInstance(runInd)=run(runInd).System.outcome;
    reactionTimeAllInstance(runInd)=run(runInd).System.reactionTime;
    
    if timeDiffVar==true
        trueThresholdAllInstance(runInd)=run(runInd).System.trueThreshold;
    end

%     initialFrequency(runInd)=run(runInd).System.initialFrequency;

    if run(runInd).System.hasAnswered==true
        nbAnswered=nbAnswered+1;
        valueTestedwhenAnswered(nbAnswered)=run(runInd).System.stateMemory(end);
        outcomeAnswered(nbAnswered)=run(runInd).System.outcome;
        reactionTimeAnswered(nbAnswered)=run(runInd).System.reactionTime;
        
        if timeDiffVar==true
            trueThresholdAnswered(nbAnswered)=run(runInd).System.trueThreshold;
        end
        
        if run(runInd).System.outcome==true
            nbCorrectAnswers=nbCorrectAnswers+1;
            valueTestedAnsweredCorrect(nbCorrectAnswers)=run(runInd).System.stateMemory(end);
            reactionTimeCorrect(nbCorrectAnswers)=run(runInd).System.reactionTime;
            
            if timeDiffVar==true
                trueThresholdCorrect(nbCorrectAnswers)=run(runInd).System.trueThreshold;
            end
            
        else
            nbInCorrectAnswers=nbInCorrectAnswers+1;
            valueTestedAnsweredInCorrect(nbInCorrectAnswers)=run(runInd).System.stateMemory(end);
            reactionTimeIncorrect(nbInCorrectAnswers)=run(runInd).System.reactionTime;
            answeredValIncorrect(nbInCorrectAnswers)=run(runInd).System.answer;
            
            if timeDiffVar==true
                trueThresholdInCorrect(nbInCorrectAnswers)=run(runInd).System.trueThreshold;
            end
        end
        
    else
        nbNotAnswered=nbNotAnswered+1;
        valueTestedwhenNotAnswered(nbNotAnswered)=run(runInd).System.stateMemory(end);
        
%         if valueTestedwhenNotAnswered(nbNotAnswered)== initialFreqGivenAllInstance(runInd)
%             nbCorrectAnswers=nbCorrectAnswers+1;
%             valueTestedAnsweredCorrect(nbCorrectAnswers)=run(runInd).System.stateMemory(end);
%             reactionTimeCorrect(nbCorrectAnswers)=run(runInd).System.reactionTime;
%         end
        
        if timeDiffVar==true
            trueThresholdwhenNotAnswered(nbNotAnswered)=run(runInd).System.trueThreshold;
        end
    end
     
end

forallInstance=[initialFreqGivenAllInstance',valueTestedAllInstance',...
                hasAnsweredAllInstance',outcomeAllInstance',reactionTimeAllInstance'];
whenAnswered=[valueTestedwhenAnswered',outcomeAnswered',reactionTimeAnswered'];
whenNotAnswered=valueTestedwhenNotAnswered';
whenCorrect=[valueTestedAnsweredCorrect',reactionTimeCorrect'];
whenInCorrect=[valueTestedAnsweredInCorrect',reactionTimeIncorrect',answeredValIncorrect'];

header_forallInstance={'initial_freq', 'valueTested', 'hasAnswered', 'outcome', 'reactionTime'};
header_whenAnswered={'valueTested', 'outcome', 'reactionTime'};
header_whenNotAnswered={'valueTested'};
header_whencorrect={'valueTested', 'reactionTime'};
header_whenInCorrect={'valueTested', 'reactionTime','AnsweresValue'};

 if timeDiffVar==true
     forallInstance=[trueThresholdAllInstance',forallInstance];
     whenAnswered=[trueThresholdAnswered',whenAnswered];
     whenNotAnswered=[trueThresholdwhenNotAnswered', whenNotAnswered];
     whenCorrect=[trueThresholdCorrect',whenCorrect];
     whenInCorrect=[trueThresholdInCorrect', whenInCorrect];
     header_forallInstance=['trueThreshold',header_forallInstance];
     header_whenAnswered=['trueThreshold',header_whenAnswered];
     header_whenNotAnswered=['trueThreshold',header_whenNotAnswered];
     header_whencorrect=['trueThreshold',header_whencorrect];
     header_whenInCorrect=['trueThreshold',header_whenInCorrect];
 end

% initialfileName=split(fileName,".");

fileName2save=strcat('extractedData_', fileName);
File2save= fullfile(path, fileName2save);

disp('3. Save data');
save(File2save, 'forallInstance','whenAnswered', 'whenNotAnswered','whenCorrect', 'whenInCorrect','header_forallInstance',...
    'header_whenAnswered','header_whenNotAnswered','header_whencorrect', 'header_whenInCorrect', 'path', 'File',...
    'nbTrials','nbAnswered', 'nbNotAnswered','nbCorrectAnswers', 'nbInCorrectAnswers')

disp('4. Completed')