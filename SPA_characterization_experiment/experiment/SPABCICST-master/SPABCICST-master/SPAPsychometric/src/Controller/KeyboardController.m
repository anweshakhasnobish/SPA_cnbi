classdef KeyboardController < handle & Controller    
    properties
        engine
        inputKeys = [];
        inputKeysLabel = {'LeftArrow', 'RightArrow'}
    end
    
    methods
        function obj = KeyboardController(engine)
            minProbability = 0;
            maxProbability = 1;
            obj@Controller(minProbability, maxProbability);
            obj.engine     = engine;
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

