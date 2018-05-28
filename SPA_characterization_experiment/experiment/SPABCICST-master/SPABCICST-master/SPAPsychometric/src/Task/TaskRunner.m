classdef TaskRunner < handle
	properties
		runs            = 0,
        trialsPerRun    = 0,
        currentTrial    = 0,
        currentRun      = 1,
        results         = []
	end
	methods
		function obj = TaskRunner(runs, trialsPerRun)
			obj.runs = runs;
			obj.trialsPerRun = trialsPerRun;
		end

		function init(obj)

		end

		function endTrial(obj, outcome)
			obj.results = [obj.results outcome];
		end

        function startBaseline(obj, dt)
        end

        function startCue(obj, dt)
        end

        function startTrial(obj, dt)
        end

        function startBreak(obj, dt)
        end

		function switchTrial(obj, dt)
            obj.currentTrial    = obj.currentTrial + 1;
        end

        function switchRun(obj, dt)
            obj.currentRun      = obj.currentRun + 1;
            obj.currentTrial    = 1;
        end

        function shouldSwitch = shouldSwitchRun(obj)
            shouldSwitch = obj.currentTrial > obj.trialsPerRun;
        end

        function done = isDone(obj)
        	done = obj.currentRun > obj.runs;
        end

        function destroy(obj)

        end
        
        function structure = convertToStruct(obj)
            structure = struct();
            structure.runs          = obj.runs;
            structure.trialsPerRun  = obj.trialsPerRun;
            structure.currentTrial  = obj.currentTrial;
            structure.currentRun    = obj.currentRun;
            structure.results       = obj.results;
        end
	end


end