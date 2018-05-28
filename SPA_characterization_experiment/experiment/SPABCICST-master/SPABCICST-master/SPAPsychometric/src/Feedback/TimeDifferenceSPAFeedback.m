classdef TimeDifferenceSPAFeedback < SPAFeedback & handle
	methods 
		function obj = TimeDifferenceSPAFeedback(system, platform)
			obj@SPAFeedback(system, platform);
        end
        
        function command = getCommandFromState(obj, state)
            if state == 0
                command = 'P0;-1;25;50;\n\r';
            else
                command = ['R0;' num2str(round(state)) ';25;50;\n\r'];
                
            end
        end
	end 
end 

