classdef VisualFeedback < Feedback & handle
	properties 
		engine,
		windowSize = [];
	end 

	methods 
		function obj = VisualFeedback(engine, system)
			obj@Feedback(system);
			obj.engine = engine;
		end

		function init(obj)
			obj.windowSize = obj.engine.getWindowSize();
		end

		function update(obj, dt)
			color = [255, 0, 0, 0.5];
			obj.engine.drawFilledRect(color,...
                obj.windowSize(3:4) ./ 2 + [obj.system.state*10 0], ...
                obj.windowSize(4)*0.05);
		end

		function endTrial(obj)

		end

		function destroy(obj)
			obj.engine.showCursor();
		end
	end 
end 