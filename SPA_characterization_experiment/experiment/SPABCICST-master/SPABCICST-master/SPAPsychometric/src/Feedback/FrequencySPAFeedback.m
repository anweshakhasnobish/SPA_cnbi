classdef FrequencySPAFeedback < SPAFeedback & handle
	methods 
		function obj = FrequencySPAFeedback(system, platform)
			obj@SPAFeedback(system, platform);
        end
        
        function command = getCommandFromState(obj, state)
            command = ['P0;3;' num2str(round(state)) ';50;\n\r'];
        end
	end 
end 

