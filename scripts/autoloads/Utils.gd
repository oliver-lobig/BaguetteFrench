extends Node

func roll_random(probabilities: Array = [], mappings: Array = []):
	var maximum = 0
	for prob in probabilities:
		maximum += prob
	randomize()
	var rand = randi_range(1,maximum)
	var minimum = 0
	var outcome = -1
	var id = 1
	for prob in probabilities:
		if rand > minimum:
			if minimum + prob >= rand:
				outcome = id
		id += 1
		minimum += prob
	if mappings.size() > 0:
		outcome = mappings[outcome - 1]
	return outcome
