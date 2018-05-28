classdef System < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        input       = 0,
        state       = 0,
        boundary    = 0,
        time        = 0,
        timeMemory  = [],
        stateMemory = [],
        inputMemory = []
    end
    
    methods
        function obj = System(boundary)
            obj.boundary    = boundary;
        end

        function init(obj)
            obj.initState();
        end

        function initState(obj)
            obj.state       =  0;
        end
        
        function update(obj, dt)
            obj.stateMemory = [obj.stateMemory; obj.state];
            obj.inputMemory = [obj.inputMemory; obj.input];
            obj.timeMemory  = [obj.timeMemory; obj.time];
            if ~obj.exploded()
                obj.time = obj.time + dt;
            end
        end
        
        function setInput(obj, newInput)
            obj.input = newInput;
        end

        function reachedLimit = exploded(obj)
            reachedLimit = (abs(obj.state) - obj.boundary) >= 0;
        end

        function reset(obj)
            obj.stateMemory = [];
            obj.inputMemory = [];
            obj.timeMemory  = [];
            obj.input       = 0;
            obj.time        = 0;
            obj.initState();
        end
        
        function structure = convertToStruct(obj)
            structure = struct();
            structure.stateMemory   = obj.stateMemory;
            structure.inputMemory   = obj.inputMemory;
            structure.timeMemory    = obj.timeMemory;
            structure.boundary      = obj.boundary;
        end
    end
end

