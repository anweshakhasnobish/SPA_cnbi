classdef GraphicalTask < handle & Task
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
        stopTaskKey = NaN
    end
    
    methods
        function obj = GraphicalTask(taskTimeProperties, controller, engine, nSystem, taskRunner, thresholdFinder)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@Task(taskTimeProperties, controller, nSystem, taskRunner, thresholdFinder);
            obj.engine = engine;            
        end

        function init(obj)
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');
            obj.engine.openWindow(0.5*screenResolution);
            obj.stopTaskKey = obj.engine.getKeyboardKey('ESCAPE');
            obj.engine.addEnabledKeyInput(obj.stopTaskKey);
            init@Task(obj);
        end

        function update(obj, dt)
            update@Task(obj, dt);
            obj.engine.updateScreen();
        end

        function updateCue(obj, dt)
            updateCue@Task(obj, dt);
            for feedbackIndex = 1:length(obj.feedbacks)
                obj.feedbacks(feedbackIndex).update(dt);
            end
        end

        function updateTrial(obj, dt)
            updateTrial@Task(obj, dt);
        end

        function updateBreak(obj, dt)
            updateBreak@Task(obj, dt);
            if obj.currentTime < obj.taskTimeProperties.breakDuration
                obj.engine.drawCenteredText(['Break ' num2str(round(obj.currentTime,1)) '/'...
                        num2str(obj.taskTimeProperties.breakDuration) '\n Trial ' num2str(obj.taskRunner.currentTrial) '/'...
                        num2str(obj.taskRunner.trialsPerRun) '\n '], [255 255 255]);
                if obj.engine.checkIfKeyPressed(obj.stopTaskKey)
                    obj.userDone = true;
                    return
                end
            end
        end

        function updateBaseline(obj, dt)
            updateBaseline@Task(obj, dt);
            if obj.currentTime < obj.taskTimeProperties.baselineDuration
                obj.engine.drawCenteredText('+', [255 255 255]);
            end
        end

        function destroy(obj)
            destroy@Task(obj);
            obj.engine.closeAllWindows();
        end
    end
end

