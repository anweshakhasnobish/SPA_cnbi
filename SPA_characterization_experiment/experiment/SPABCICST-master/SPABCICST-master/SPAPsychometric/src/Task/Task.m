classdef Task < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller,
        system,
        taskRunner,
        taskTimeProperties,
        state,
        thresholdFinder,
        feedbacks       = [],
        currentTime     = 0, % second
        userDone        = false,   
        savingFolder    = './',
        currentSessionRun = 0
    end
    properties (Constant)
        Created         = 0, 
        Initialized     = 1, 
        Baseline        = 2, 
        Cue             = 3, 
        RunTrial        = 4, 
        Break           = 5, 
        SwitchTrial     = 6, 
        SwitchRun       = 7
    end
    
    methods
        function obj = Task(taskTimeProperties, controller, nSystem, taskRunner, thresholdFinder)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.taskTimeProperties  = taskTimeProperties;
            obj.controller          = controller;
            obj.system              = nSystem;
            obj.taskRunner          = taskRunner;
            obj.state               = Task.Created;
            obj.thresholdFinder     = thresholdFinder;
        end

        function init(obj)
            disp('Init Task');
            obj.controller.initController();
            obj.system.init();
            obj.taskRunner.init();
            obj.state = Task.Initialized;
            for feedbackIndex = 1:length(obj.feedbacks)
                obj.feedbacks(feedbackIndex).init();
            end
            obj.currentSessionRun = obj.getCurrentRunIndex();
        end

        function addRecorder(obj, recorder)
            obj.recorders = [obj.recorders recorder];
        end

        function addFeedback(obj, feedback)
            obj.feedbacks = [obj.feedbacks feedback];
        end

        function start(obj)
            if obj.state~= Task.Initialized 
                error('Task should be initialized first');
            end
            expectedElapsedTime = 1 / obj.taskTimeProperties.updateRate;
            tic;
            while ~obj.isDone()
                elapsedTimeInSeconds  = toc;
                if elapsedTimeInSeconds > expectedElapsedTime
                    tic;
                    obj.update(elapsedTimeInSeconds);
                    obj.currentTime = obj.currentTime + elapsedTimeInSeconds;
                    obj.throwWarningIfSlowDown(elapsedTimeInSeconds, expectedElapsedTime);
                end
            end
            obj.saveRun();
        end

        function update(obj, dt)
            switch obj.state
                case Task.Baseline
                    obj.updateBaseline(dt);
                case Task.Cue
                    obj.updateCue(dt);
                case Task.RunTrial
                    obj.updateTrial(dt);
                case Task.Break
                    obj.updateBreak(dt);
                case Task.SwitchTrial 
                    obj.updateSwitchTrial(dt);
                case Task.SwitchRun
                    obj.updateSwitchRun(dt);
                otherwise
                    obj.system.valueToTest  = obj.thresholdFinder.getNewDifficulty();
                    obj.currentTime             = 0;
                    obj.state                   = Task.Break;
                    obj.taskRunner.startBreak(dt);
            end
        end

        function throwWarningIfSlowDown(obj, elapsedTimeInSeconds, expectedElapsedTime)
            if((elapsedTimeInSeconds - expectedElapsedTime)/(expectedElapsedTime) > ...
                obj.taskTimeProperties.precision)
                warning(['Program is running slower than expected: ' ...
                    num2str(round(1/elapsedTimeInSeconds)) 'Hz instead of ' ...
                    num2str(round(obj.taskTimeProperties.updateRate)) 'Hz in state : ' num2str(obj.state)])
            end
        end


        function updateBaseline(obj, dt)
            if obj.currentTime >= obj.taskTimeProperties.baselineDuration
                obj.purge();
                obj.state = Task.Cue;
                obj.updateTrial(0.001);
                obj.taskRunner.startCue(dt);
                obj.currentTime     = 0;
            end
        end

        function updateCue(obj, dt)
            if obj.currentTime >= obj.taskTimeProperties.cueDuration
                obj.state = Task.RunTrial;
                obj.taskRunner.startTrial(dt);
                obj.currentTime     = 0;
            end
        end

        function updateTrial(obj, dt)
            if ~obj.system.exploded() && obj.currentTime < obj.taskTimeProperties.trialDuration
                if(obj.controller.update(dt))
                    obj.system.setInput(obj.controller.input);
                end
                obj.system.update(dt);
                for feedbackIndex = 1:length(obj.feedbacks)
                    obj.feedbacks(feedbackIndex).update(dt);
                end
            else
                for feedbackIndex = 1:length(obj.feedbacks)
                    obj.feedbacks(feedbackIndex).endTrial();
                end
                obj.taskRunner.endTrial(obj.system.outcome);
                obj.thresholdFinder.update(obj.system.valueToTest, obj.system.outcome);
                obj.save();
                if rand() > 0.9
                    obj.system.valueToTest = 0;
                else
                    obj.system.valueToTest = obj.thresholdFinder.getNewDifficulty();
                end
                obj.currentTime     = 0;
                obj.state           = Task.Break;
                obj.taskRunner.startBreak(dt);
            end
        end

        function updateBreak(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.breakDuration
                obj.taskRunner.switchTrial(dt);
                obj.state = Task.SwitchTrial;
                obj.currentTime     = 0;
            end
        end

        function updateSwitchTrial(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.switchTrialDuration
                if obj.taskRunner.shouldSwitchRun()
                    obj.taskRunner.switchRun();
                    obj.state = Task.SwitchRun;
                else
                    obj.taskRunner.startBaseline();
                    obj.state = Task.Baseline;
                end
                obj.currentTime     = 0;
            end
        end

        function updateSwitchRun(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.switchRunDuration
                obj.saveRun();
                obj.taskRunner.startBaseline(dt);
                obj.state = Task.Baseline;
                obj.currentTime     = 0;
            end
        end

        function purge(obj)
            obj.controller.purge();
            obj.system.reset();
        end

        function save(obj)
            trial = struct('Controller', obj.controller.convertToStruct(), ...
                'System', obj.system.convertToStruct(), ...
                'TaskRunner', obj.taskRunner.convertToStruct(), ...
                'ThresholdFinder', obj.thresholdFinder.convertToStruct());
            filename = [obj.savingFolder 'Run_' ...
                num2str(obj.currentSessionRun + obj.taskRunner.currentRun) '_Trial_' ...
                num2str(obj.taskRunner.currentTrial)];
            save(filename, 'trial');
        end
        
        function currentRunIndex = getCurrentRunIndex(obj)
            files = dir([obj.savingFolder '*.mat']);
            if length(files) > 0
                runIndices = zeros(length(files),1);
                for indexFile = 1:length(files)
                    filename = files(indexFile).name;
                    runIndices(indexFile) = str2double(filename(5));
                    currentRunIndex = max(runIndices);
                end
            else
                currentRunIndex = 0;
            end
            
        end
        
        function saveRun(obj)
            files = dir([obj.savingFolder 'Run_*_Trial_*.mat']);
            runIndices = zeros(length(files),1);
            for indexFile = 1:length(files)
                filename = files(indexFile).name;
                runIndices(indexFile) = str2double(filename(5));
            end
            [runIndex] = unique(runIndices);
            for indexRun = 1:length(runIndex)
                run = struct([]);
                countRun = 1;
                for indexFile = 1:length(files)
                    if runIndex(indexRun) == runIndices(indexFile)
                        trial = load([obj.savingFolder files(indexFile).name]);
                        if countRun == 1
                            run = trial.trial;
                        else
                            run(countRun) = trial.trial;
                        end
                        countRun = countRun + 1;
                    end
                end
                save([obj.savingFolder 'Run_' num2str(runIndex(indexRun))], 'run');
            end
        end

        function done = isDone(obj)
            done = obj.userDone | obj.taskRunner.isDone();
        end

        function destroy(obj)
            obj.controller.destroy();
            obj.taskRunner.destroy();
            for feedbackIndex = 1:length(obj.feedbacks)
                obj.feedbacks(feedbackIndex).destroy();
            end
        end
    end
end