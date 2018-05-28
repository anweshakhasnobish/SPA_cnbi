classdef FrequencyDifferenceThresholdTesterSystem < handle & ThresholdTesterSystem
    
    properties
        initialFrequency = 5;
    end
    
    methods
        function obj = FrequencyDifferenceThresholdTesterSystem(initialFrequency,...
                timeBeforeTest)
            obj@ThresholdTesterSystem(timeBeforeTest);
            obj.initialFrequency = initialFrequency;
        end
        
        function test(obj)
            obj.hasBeenTested   = true;
            obj.state           = obj.initialFrequency + (rand() - 0.5) * obj.valueToTest;
            
            if obj.state>40                     % 40Hz is the maximal frequency supported by the hardware
                obj.state=40;
                obj.valueToTest=40-obj.initialFrequency;
            end
            
           if obj.state<5
                obj.state=5;
                obj.valueToTest=obj.initialFrequency-5;  % 5Hz in the minimal Frequency supported by hardware
           end
           
        end
        
        function validateAnswer(obj)
            if obj.state < obj.initialFrequency && obj.answer == 1
                obj.outcome = true;
            elseif obj.state <= obj.initialFrequency && obj.answer == 2
                obj.outcome = false;
            elseif obj.state > obj.initialFrequency && obj.answer == 2
                obj.outcome = true;
            elseif obj.state >= obj.initialFrequency && obj.answer == 1
                obj.outcome = false;
            end
        end
       
        function reset(obj)
            reset@ThresholdTesterSystem(obj);
            obj.state           = obj.initialFrequency;
        end
        
        function structure = convertToStruct(obj)
            structure = convertToStruct@ThresholdTesterSystem(obj);
            structure.initialFrequency = obj.initialFrequency;
        end
    end
end

