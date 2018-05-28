function runClassic(varargin)
	addpath(genpath('.'))
	defaultRuns				= 1;
	defaultTrialsPerRun 	= 35;
    defaultController       = 'KeyboardController';
    defaultFeedback         = {'Visual', 'FrequencySPA'};
    defaultSystem           =  'ThresholdTester';
	p = inputParser;
	addOptional(p,'runs', defaultRuns, @isValidScalarPosNum);
	addOptional(p,'trialsPerRun', defaultTrialsPerRun, @isValidScalarPosNum);
    addOptional(p,'controller', defaultController, @ControllerFactory.isValidController);
    addOptional(p,'feedbacks', defaultFeedback, @areValidFeedbacks);
    addOptional(p,'system', defaultSystem, @SystemFactory.isValidSystemMode)
    addOptional(p,'savingFolder', './', @isValidFolder)
	parse(p,varargin{:});

	task = TaskFactory.createTaskFromParameters(p.Results);
	task.init();
	task.start();
	task.destroy();
end

function valid = isValidScalarPosNum (x)
	valid = isnumeric(x) && isscalar(x) && (x > 0);
end

function valid = areValidFeedbacks(feedbacks)
	valid = true;
	for feedbackIndex = 1:length(feedbacks)
		if ~FeedbackFactory.isValidFeedback(feedbacks{feedbackIndex})
			valid = false;
		end
	end
end

function valid = isValidFolder(folder)
	valid = exist(folder,'dir') == 7;
end
