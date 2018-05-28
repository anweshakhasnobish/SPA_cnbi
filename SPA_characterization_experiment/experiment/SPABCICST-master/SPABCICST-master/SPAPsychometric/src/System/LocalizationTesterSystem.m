classdef LocalizationTesterSystem < handle & TesterSystem
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = LocalizationTesterSystem(timeBeforeTest)
            obj@TesterSystem(timeBeforeTest);
        end
        
        function test(obj)
            obj.state           = obj.valueToTest;
            obj.hasBeenTested   = true;
        end
        
        function validateAnswer(obj)
            obj.outcome = (obj.state == obj.answer);
        end
    end
end

