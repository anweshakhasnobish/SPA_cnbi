classdef PositionSPAFeedbackAllOn < SPAFeedback & handle
	methods 
		function obj = PositionSPAFeedbackAllOn(system, platform)
			obj@SPAFeedback(system, platform);
        end
        
        function command = getCommandFromState(obj, state)
            
             if state == 0
%                   for spa_nb=0:7
                      
                        command = ['R0;0;15;50;','R0;7;15;50;\n\r'];
                                              
%                   end
            else
                command = ['R0;' num2str(round(state-1)) ';25;50;\n\r'];
             end
        end 
    
    end
end

