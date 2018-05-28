classdef PositionSPAFeedback < SPAFeedback & handle
	methods 
		function obj = PositionSPAFeedback(system, platform)
			obj@SPAFeedback(system, platform);
        end
        
        function command = getCommandFromState(obj, state)
            command = ['P0;' num2str(state-1) ';25;50;\n\r'];
        end
	end 
end 

