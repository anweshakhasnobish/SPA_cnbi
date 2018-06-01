classdef PythonArduino < handle & Serial
    properties
        filenameWrite = '../tmp/arduino.txt'
        filenamelock = '../tmp/arduino.lock'
        lockFile
    end
    methods
        function obj = PythonArduino(port, baudRate)
            obj.port = port;
            obj.baudRate = baudRate;
            
            import java.io.File
            obj.lockFile = java.io.File(obj.filenamelock);
            obj.lockFile.delete;
            delete(obj.filenameWrite)
        end
        
        function connect(obj)
            obj.lockFile.delete;
            commandStr = 'gnome-terminal tab -e ''python3 ../python/arduinoCommunication.py''';
%             commandStr = 'start cmd.exe /c ''python3 ../python/arduinoCommunication.py''';
            %[status, commandOut] = system(commandStr); 

            %if status ~= 0
%                error(['Impossible to start arduino from Python:' commandOut]); 
            %end
        end
        
        function sendCommand(obj,command)
            if ~obj.lockFile.exists
                fclose(fopen(obj.filenamelock,'w'));
                fileID = fopen(obj.filenameWrite,'w');
                fprintf(fileID, command);
                fclose(fileID);
                obj.lockFile.delete;
            end
        end
        
        function flushBuffferFromDevice(obj)
            obj.sendCommand('flushInput\n');
        end
        
        function disconnect(obj)
            obj.sendCommand('disconnect\n');
        end
    end
end