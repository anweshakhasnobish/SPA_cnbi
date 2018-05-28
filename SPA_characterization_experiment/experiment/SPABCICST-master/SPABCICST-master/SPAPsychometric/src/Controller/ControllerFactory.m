classdef ControllerFactory < handle
	methods(Static)
		function controller = createController(varargin)
			p = inputParser;
			addRequired(p,'mode', @ControllerFactory.isValidController);
			addRequired(p,'engine', @ControllerFactory.isValidEngine);
			parse(p,varargin{:});

			if strcmp(p.Results.mode, 'KeyboardController')
				disp('Create Keyboard Controller');
				controller = KeyboardController(p.Results.engine);
            elseif strcmp(p.Results.mode, 'NumPadController')
				disp('Create Numeric Pad Controller');
				controller = NumPadController(p.Results.engine);
			end
		end

		function valid = isValidController(controllerMode)
			valid = true;
			if ~ischar(controllerMode) || ...
                    (~strcmp(controllerMode,'KeyboardController') && ...
                    ~strcmp(controllerMode,'NumPadController') && ...
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
	end
end