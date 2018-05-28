classdef NumPadController < handle & Controller    
    properties
        engine
        inputKeys = [];
        inputKeysLabel
    end
    
    methods
        function obj = NumPadController(engine)
            minProbability = 0;
            maxProbability = 1;
            obj@Controller(minProbability, maxProbability);
            obj.engine     = engine;
            obj.inputKeysLabel = cell(9,1);
            for numpadIndex = 1:9
                obj.inputKeysLabel{numpadIndex} = num2str(numpadIndex);
            end
        end

        function initController(obj)
            for keyIndex = 1:length(obj.inputKeysLabel)
                obj.inputKeys(keyIndex) = obj.engine.getKeyboardKey(obj.inputKeysLabel{keyIndex});
                obj.engine.addEnabledKeyInput(obj.inputKeys(keyIndex));
            end
        end
        
        function updated = update(obj, dt)
            updated = false;
            for keyIndex = 1:length(obj.inputKeys)
                if obj.engine.checkIfKeyPressed(obj.inputKeys(keyIndex))
                    obj.input       = keyIndex;
                    obj.inputMemory = [obj.inputMemory obj.input];
                    updated = true;
                end
            end
        end

        function destroy(obj)
        end
    end
end

