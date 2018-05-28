classdef FeedbackFactory < handle
	methods(Static)
		function feedback = createFeedback(varargin)
			p = inputParser;
			addRequired(p,'mode', @FeedbackFactory.isValidFeedback);
			addRequired(p,'system', @FeedbackFactory.isValidSystem);
			addOptional(p,'engine', NaN, @FeedbackFactory.isValidEngine);
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Visual')
				disp('Create Visual Feedback');
				feedback = VisualFeedback(p.Results.engine, p.Results.system);
            elseif strcmp(p.Results.mode, 'LocalizationVisual')
				disp('Create Localization Visual Feedback');
				feedback = LocalizationFeedback(p.Results.engine, p.Results.system);
            elseif strcmp(p.Results.mode, 'PositionSPA')
				disp('Create Position Soft Pneumatic Vibro Tactile Feedback');
				feedback = PositionSPAFeedback (p.Results.system, 'Python');
            elseif strcmp(p.Results.mode, 'PositionSPAon')
				disp('Create Position Soft Pneumatic Vibro Tactile Feedback while all are ON');
				feedback = PositionSPAFeedbackAllOn (p.Results.system, 'Python');
            elseif strcmp(p.Results.mode, 'FrequencySPA')
				disp('Create Frequency Soft Pneumatic Vibro Tactile Feedback');
				feedback = FrequencySPAFeedback (p.Results.system, 'Python');
            elseif strcmp(p.Results.mode, 'IntensitySPA')
				disp('Create Intensity Soft Pneumatic Vibro Tactile Feedback');
				feedback = IntensitySPAFeedback (p.Results.system, 'Python');
            elseif strcmp(p.Results.mode, 'TimeDifferenceSPA')
                disp('Create Time difference Soft Pneumatic Vibro Tactile Feedback');
				feedback = TimeDifferenceSPAFeedback(p.Results.system, 'Python');
			end
		end

		function valid = isValidFeedback(controllerMode)
			valid = true;
			if ~ischar(controllerMode) || (~strcmp(controllerMode,'Visual') && ...
				~strcmp(controllerMode,'PositionSPA') && ...
                ~strcmp(controllerMode,'PositionSPAon') && ...
                ~strcmp(controllerMode,'FrequencySPA') && ...
                ~strcmp(controllerMode,'IntensitySPA') && ...
                ~strcmp(controllerMode,'LocalizationVisual') && ...
                ~strcmp(controllerMode,'TimeDifferenceSPA') && ...
				~strcmp(controllerMode,'None'))
				valid = false;
			end
		end

		function valid = isValidEngine(engine)
			valid = true;
			if ~isa(engine,'GraphicalEngine')
				valid = false;
			end
		end

		function valid = isValidSystem(currentSystem)
			valid = true;
			if ~isa(currentSystem,'System')
				valid = false;
			end
		end
	end
end