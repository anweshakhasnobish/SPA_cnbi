function classifer_metrics = classifierMetric(actualClassLabels, predictedClassLabels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[cm,order]=confusionmat(actualClassLabels, predictedClassLabels);    % confusion matrix

totalInstances_CL1=numel(predictedClassLabels);

classes=unique(predictedClassLabels);

sumd=0;sumall=0;
  
TP=cm(1,1);                  % true positive
TN=cm(2,2);                  % true negative
FN=cm(1,2);                  % false negative = Type II error
FP=cm(2,1);                  % false positive = Type I error
Pos= TP+FN;
Neg= FP+TN;
T2ErR=FN/Pos;               % Type-II Errror Rate
T1ErR=FP/Neg;               % Type-I Error rate
TPR= TP/Pos;           % True positive rate= hit rate=recall= SENSITIVITY
TNR=TN/Neg;            % True negative rate= Specificity
nume=2*TP;
deno=(2*TP)+FP+FN;
F1= nume/deno;         % F1 score= F-measure

     for l=1:length(order)
         for m=1:length(order)    
             if(l==m)
                sumd=sumd+cm(l,m);
             end
                sumall=sumall+cm(l,m);
          end
     end
      classAcc=sumd/sumall;
      
      classifer_metrics=struct('Type2_ErrorRate',T2ErR,'Type1_ErrorRate', T1ErR,...
                                'Sense_TPR',TPR,'Spec_TNR',TNR,'Fmeasure',F1,'ClassificationAccuracy',classAcc);

end

