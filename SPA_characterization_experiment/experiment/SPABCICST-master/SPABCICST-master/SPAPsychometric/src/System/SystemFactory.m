classdef SystemFactory < handle
	methods(Static)
		function newSystem = createSystem(varargin)
            p = inputParser;
			addRequired(p,'mode', @SystemFactory.isValidSystemMode);
            parse(p, varargin{:});
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');
            timeBeforeTesting = 2; %s
			if strcmp(p.Results.mode, 'Simple')
                disp('Create Visual Simple System');
                newSystem = System(screenResolution(3));
            elseif strcmp(p.Results.mode, 'ThresholdTester')
                disp('Create Visual Threshold Tester');
                newSystem = ThresholdTesterSystem(timeBeforeTesting);
            elseif strcmp(p.Results.mode, 'TimeDifferenceThresholdTester')
                disp('Create Visual Time Difference Threshold Tester');
                newSystem = TimeDifferenceThresholdTesterSystem(timeBeforeTesting);
            elseif strcmp(p.Results.mode, 'FrequencyDifferenceThresholdTester')
                disp('Create Visual Time Difference Threshold Tester');
                newSystem = FrequencyDifferenceThresholdTesterSystem(20, timeBeforeTesting);
            elseif strcmp(p.Results.mode, 'LocalizationTester')
                disp('Create Visual Time Difference Threshold Tester');
                newSystem = LocalizationTesterSystem(timeBeforeTesting);
            end
        end
        
        function valid = isValidSystemMode(systemMode)
            valid = false;
            if ischar(systemMode) && (strcmp(systemMode, 'Simple') || ...
                    strcmp(systemMode, 'ThresholdTester') || ...
                    strcmp(systemMode, 'TimeDifferenceThresholdTester') || ...
                    strcmp(systemMode, 'FrequencyDifferenceThresholdTester') || ...
                    strcmp(systemMode, 'LocalizationTester'))
                valid = true;
            end
        end
	end
end