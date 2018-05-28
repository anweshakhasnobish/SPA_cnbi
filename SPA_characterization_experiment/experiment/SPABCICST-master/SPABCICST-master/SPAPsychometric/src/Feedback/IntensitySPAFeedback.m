classdef IntensitySPAFeedback < SPAFeedback & handle
	methods 
		function obj = IntensitySPAFeedback(system, platform)
			obj@SPAFeedback(system, platform);
        end
        
        function command = getCommandFromState(obj, state)
            command = ['P0;2;25;' num2str(state) ';\n\r'];
        end
	end 
end 