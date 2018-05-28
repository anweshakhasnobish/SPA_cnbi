classdef ThresholdTesterSystem < handle & TesterSystem
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = ThresholdTesterSystem(timeBeforeTest)
            obj@TesterSystem(timeBeforeTest);
        end
        
        function test(obj)
            obj.state           = obj.valueToTest;
            obj.hasBeenTested   = true;
        end
        
        function validateAnswer(obj)
            if obj.state == 0 && obj.answer == 1
                obj.outcome = true;
            elseif obj.state == 0 && obj.answer == 2
                obj.outcome = false;
            elseif obj.state > 0 && obj.answer == 2
                obj.outcome = true;
            elseif obj.state > 0 && obj.answer == 1
                obj.outcome = false;
            end
        end
    end
end

