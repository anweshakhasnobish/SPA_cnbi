classdef DifficultyUpdater < handle
	properties

	end

	methods(Abstract)
		update(obj, testedValue, response)
		lambda = getNewDifficulty(obj)
        structure = convertToStruct(obj)
	end

end