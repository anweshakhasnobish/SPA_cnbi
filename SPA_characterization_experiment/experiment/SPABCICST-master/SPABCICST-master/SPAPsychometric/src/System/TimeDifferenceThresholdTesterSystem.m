classdef TimeDifferenceThresholdTesterSystem < handle & ThresholdTesterSystem
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    properties
        trueThreshold = 0
    end
    
    methods
        function obj = TimeDifferenceThresholdTesterSystem(timeBeforeTest)
            obj@ThresholdTesterSystem(timeBeforeTest);
        end
        
        function test(obj)
            obj.state           = 1;
            if obj.time > obj.timeBeforeTest + 10^(-obj.valueToTest)
                obj.trueThreshold = 10^(-obj.valueToTest);
                obj.state = 2;
                obj.hasBeenTested   = true;
            end 
        end
        
        function validateAnswer(obj)
            if obj.valueToTest == 0 && obj.answer == 1
                obj.outcome = true;
            elseif obj.valueToTest == 0 && obj.answer == 2
                obj.outcome = false;
            elseif obj.valueToTest > 0 && obj.answer == 2
                obj.outcome = true;
            elseif obj.valueToTest > 0 && obj.answer == 1
                obj.outcome = false;
            end
        end
        
        function structure = convertToStruct(obj)
            structure = convertToStruct@ThresholdTesterSystem(obj);
            structure.trueThreshold = obj.trueThreshold;
        end
    end
end

