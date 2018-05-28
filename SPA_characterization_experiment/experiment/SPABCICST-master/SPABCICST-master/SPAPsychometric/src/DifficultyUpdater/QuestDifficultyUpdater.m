classdef QuestDifficultyUpdater < handle & DifficultyUpdater
	properties
		quest = []
		prior
		maxValue,
		priorStd,
		probThreshold,
		sigmoidSlope,
		chanceLevel,
		maxProbability,
        inversed = false
	end

	methods
		function obj = QuestDifficultyUpdater(prior, maxValue, priorStd, ...
                probThreshold, sigmoidSlope, maxProbability, chanceLevel, inversed)
			obj.prior 			= prior;
			obj.maxValue 		= maxValue;
			obj.priorStd 		= priorStd;
			obj.sigmoidSlope 	= sigmoidSlope;
			obj.probThreshold 	= probThreshold;
			obj.maxProbability 	= maxProbability;
			obj.chanceLevel 	= chanceLevel;
            obj.inversed        = inversed;
			obj.quest 			= QuestCreate(...
				log(obj.prior./obj.maxValue),...
				obj.priorStd,...
				obj.probThreshold,...
				obj.sigmoidSlope,...
				1-obj.maxProbability,...
				obj.chanceLevel);
		end

		function update(obj, testedValue, response)
            if obj.inversed
                response = ~response;
            end
            obj.quest = QuestUpdate(obj.quest,log(testedValue./obj.maxValue), response);
		end
		function lambda = getNewDifficulty(obj)
			lambda = obj.maxValue.*exp(QuestMean(obj.quest));
        end
        function structure = convertToStruct(obj)
            structure = struct();
            structure.prior             = obj.prior;
            structure.maxValue          = obj.maxValue;
            structure.priorStd          = obj.priorStd;
            structure.probThreshold     = obj.probThreshold;
            structure.sigmoidSlope      = obj.sigmoidSlope;
            structure.chanceLevel       = obj.chanceLevel;
            structure.maxProbability    = obj.maxProbability;
            structure.quest             = obj.quest;
        end
	end

end