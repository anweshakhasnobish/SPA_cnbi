classdef Serial < handle
    %SERIAL Summary of this class goes here
    %   Detailed explanation goes here
    properties
        port,
        baudRate
    end
    
    methods (Abstract)
        connect(obj)
        sendCommand(obj, command)
        flushBuffferFromDevice(obj)
        disconnect(obj)
    end
end

