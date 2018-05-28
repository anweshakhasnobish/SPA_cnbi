classdef TesterSystem < handle & System
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hasAnswered     = false,
        answer          = 0,
        timeBeforeTest  = 2, %s
        hasBeenTested   = false,
        reactionTime    = 0
        outcome         = false
        valueToTest     = 0
    end
    
    methods (Abstract)
        test(obj)
        validateAnswer(obj)
    end
    
    methods
        function obj = TesterSystem(timeBeforeTest)
            obj@System(0);
            obj.timeBeforeTest = timeBeforeTest;
        end
        
        function update(obj, dt)
            if obj.time > obj.timeBeforeTest && ~obj.hasBeenTested
                obj.test();
            end
            update@System(obj, dt);
        end
        
        function setInput(obj, newInput)
            if obj.hasBeenTested
                obj.hasAnswered = true;
                obj.answer      = newInput;
                obj.input       = newInput * obj.valueToTest;
                obj.reactionTime = obj.time - obj.timeBeforeTest;
                obj.validateAnswer();
            end
        end

        function reachedLimit = exploded(obj)
            reachedLimit = obj.hasAnswered;
        end

        function reset(obj)
            reset@System(obj);
            obj.hasAnswered     = false;
            obj.answer          = 0;
            obj.hasBeenTested   = false;
        end
        
        function structure = convertToStruct(obj)
            structure = convertToStruct@System(obj);
            structure.hasAnswered       = obj.hasAnswered;
            structure.answer            = obj.answer;
            structure.timeBeforeTest    = obj.timeBeforeTest;
            structure.hasBeenTested     = obj.hasBeenTested;
            structure.reactionTime      = obj.reactionTime;
            structure.outcome           = obj.outcome;
            structure.valueToTest       = obj.valueToTest;
        end
    end
end

