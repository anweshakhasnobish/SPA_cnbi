classdef MatlabArduino < handle & Serial
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        arduinoDevice
    end
    
    methods
        function obj = MatlabArduino(port, baudRate)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.port = port;
            obj.baudRate = baudRate;
            obj.arduinoDevice = serial(obj.port, 'BaudRate', obj.baudRate);
        end
        
        function connect(obj)
            disp('Connecting to device');
			fopen(obj.arduinoDevice);
			disp('Connected');
            pause(4);
        end
        
        function sendCommand(obj,command)
            fprintf(obj.arduinoDevice, command);
        end
        
        function flushBuffferFromDevice(obj)
            flushinput(obj.arduinoDevice);
        end
        
        function disconnect(obj)
           	fclose(obj.arduinoDevice);
        end
    end
end

