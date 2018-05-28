classdef SPAFeedback < Feedback & handle
	properties 
		arduinoDevice
        previousState = 0;
	end 

	methods 
		function obj = SPAFeedback(system, platform)
			obj@Feedback(system);
            if strcmp(platform, 'MATLAB')
%                 obj.arduinoDevice = MatlabArduino('/dev/ttyUSB0', 115200);
                obj.arduinoDevice = MatlabArduino('/dev/ttyACM0', 115200);
%                   obj.arduinoDevice = MatlabArduino('COM6', 115200);
            elseif strcmp(platform, 'Python')
%                 obj.arduinoDevice = PythonArduino('/dev/ttyUSB0', 115200);
                obj.arduinoDevice = PythonArduino('/dev/ttyACM0', 115200);
%                   obj.arduinoDevice = PythonArduino('COM6', 115200);
            end
		end

		function init(obj)
			obj.arduinoDevice.connect();
% 			obj.arduinoDevice.sendCommand('P0;-1;10;50;\n\r');
% 			obj.arduinoDevice.flushBuffferFromDevice();
		end

		function update(obj, dt)
			obj.sendStateToDevice(obj.system.state);
		end

		function answer = sendStateToDevice(obj, state)
			answer = false;
            if obj.previousState ~= state
                cmd = obj.getCommandFromState(state);
                disp(cmd);
                obj.arduinoDevice.sendCommand(cmd);
                obj.previousState = state;
            end
            obj.arduinoDevice.flushBuffferFromDevice();
		end

		function endTrial(obj)
% 			pause(0.1);
			disp('End Trial for PneumaticVibroTactileFeedback');
			cmd = 'P0;-1;25;50;';
			disp(cmd);
% 			obj.arduinoDevice.flushBuffferFromDevice();
            obj.arduinoDevice.sendCommand(cmd);
		end

		function destroy(obj)
			obj.arduinoDevice.disconnect();
		end
    end 
    methods (Abstract)
        command = getCommandFromState(obj, state)
    end
end 

