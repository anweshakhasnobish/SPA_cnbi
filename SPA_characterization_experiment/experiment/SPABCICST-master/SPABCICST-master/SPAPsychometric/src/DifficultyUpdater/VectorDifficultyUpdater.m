classdef VectorDifficultyUpdater < handle & DifficultyUpdater
	properties
		values,
		weights,
        count
	end

	methods
		function obj = VectorDifficultyUpdater(values, varargin)
			p = inputParser;
			addRequired(p,'values');
			addOptional(p,'weights', []);
			parse(p, values, varargin{:});
			obj.weights = 1/length(p.Results.values) * ones(length(p.Results.values));
			obj.values = p.Results.values;
			if length(p.Results.weights) == length(p.Results.values)
				obj.weights = p.Results.weights / sum(p.Results.weights);				
            end
            obj.count = zeros(length(values),1);
		end

		function update(obj, testedValue, response)
            obj.count(obj.values == testedValue) = obj.count(obj.values == testedValue) + 1;
		end
		
		function lambda = getNewDifficulty(obj)
			index 	= find(rand(1)<=cumsum(obj.weights),1);
			lambda 	= obj.values(index);
        end
        
        function structure = convertToStruct(obj)
            structure = struct();
            structure.values    = obj.values;
            structure.weights   = obj.weights;
        end
	end
end