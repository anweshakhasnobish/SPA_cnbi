classdef LocalizationFeedback < VisualFeedback & handle
	properties 
		nbLocations = 8,
        giveSolution = true,
        locationOffset
	end 

	methods 
		function obj = LocalizationFeedback(engine, system)
			obj@VisualFeedback(engine, system);
        end
        
        function init(obj)
            init@VisualFeedback(obj);
            obj.locationOffset = obj.windowSize(3) / obj.nbLocations / 2;
        end

		function update(obj, dt)
            color = [255, 0, 0, 1];
            colorTrueState = [0, 255, 0, 1];
            for locationIndex = 1:obj.nbLocations
                position = [(locationIndex * 1.5) * obj.locationOffset obj.windowSize(4) ./ 2];
                if obj.system.state == locationIndex
                    obj.engine.drawText(num2str(locationIndex), position, color);
                else
                    obj.engine.drawText(num2str(locationIndex), position, colorTrueState);
                end
            end
        end
	end 
end 