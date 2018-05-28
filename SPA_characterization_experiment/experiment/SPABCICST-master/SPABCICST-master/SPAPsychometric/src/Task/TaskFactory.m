classdef TaskFactory < handle
	methods(Static)
        function task = createTaskFromParameters(params)
			engine 	= GraphicalEngine(2);
            timeProperties 		= TaskTimeProperties(10, 0, 2, 0, 0, 0, 0, 60);

            newSystem   = SystemFactory.createSystem(params.system);
			controller 	= ControllerFactory.createController(...
				params.controller, engine);
			taskRunner  = TaskRunner(params.runs, params.trialsPerRun);
            if strcmp(params.system,'ThresholdTester')
                thresholdFinder 	= QuestDifficultyUpdater(...
                    20, 50, 5, 0.75, 3.5, 0.99, 0.5, false);
            elseif strcmp(params.system,'TimeDifferenceThresholdTester')
                thresholdFinder 	= QuestDifficultyUpdater(...
                    3, 5, 1, 0.75, 3.5, 0.99, 0.5, true);
            elseif strcmp(params.system,'FrequencyDifferenceThresholdTester')
                thresholdFinder 	= QuestDifficultyUpdater(...
                    5, 10, 2, 0.75, 3.5, 0.99, 0.5, false);
            elseif strcmp(params.system,'LocalizationTester')
                thresholdFinder 	= VectorDifficultyUpdater(...
                    1:8, ones(8,1));
            end
            
			task = TaskFactory.createTask('Graphic', controller, newSystem, ...
				thresholdFinder, taskRunner, timeProperties, engine);
            
            task.savingFolder = params.savingFolder;
			
			for feedbackIndex = 1:length(params.feedbacks)
				task.addFeedback(FeedbackFactory.createFeedback(...
					params.feedbacks{feedbackIndex}, ...
					newSystem, ...
					engine));
			end
		end
    
		function task = createTask(varargin)
			p = inputParser;
			defaultEngine = [];
			addRequired(p,'mode', @TaskFactory.isValidTask);
			addRequired(p,'controller');
			addRequired(p,'system');
            addRequired(p,'thresholdFinder');
			addRequired(p,'taskRunner');
			addRequired(p,'taskTimeProperties');
			addOptional(p,'engine', defaultEngine);
			
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create visual task');
				task = GraphicalTask(...
					p.Results.taskTimeProperties,...
					p.Results.controller,...
					p.Results.engine,...
					p.Results.system, ...
					p.Results.taskRunner,...
                    p.Results.thresholdFinder);
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden task');
				task = Task(...
					p.Results.taskTimeProperties,...
					p.Results.controller,...
					p.Results.system, ...
					p.Results.taskRunner,...
                    p.Results.thresholdFinder);
			end
		end

		function valid = isValidTask(taskMode)
			valid = true;
			if ~ischar(taskMode) || (~strcmp(taskMode,'Graphic') && ...
				~strcmp(taskMode,'None'))
				valid = false;
			end
		end
	end
end