class_name AliasMethodRandomizer extends RefCounted

var alias: Array[int];
var probability: Array[float];

# O(n) time complexity, but only happens once upon initialization. Only need to re-initialize if weights (input probabilities) change.
func _init(input_probabilities: Array[float] = []) -> void:
	probability = [];
	alias = [];
	probability.resize(input_probabilities.size());
	alias.resize(input_probabilities.size());
	
	var average: float = 1.0 / input_probabilities.size();
	
	var probabilities: Array[float];
	probabilities.resize(input_probabilities.size());
	for i in input_probabilities.size():
		probabilities[i] = input_probabilities[i];
	
	var small: Array[int];
	var large: Array[int];
	
	for i in probabilities.size():
		if(probabilities[i] >= average):
			large.append(i);
		else:
			small.append(i);
	
	while(!small.is_empty() && !large.is_empty()):
		var less: int = small.pop_back();
		var more: int = large.pop_back();
		
		probability[less] = probabilities[less] * probabilities.size();
		alias[less] = more;
		
		probabilities[more] = (probabilities[more] + probabilities[less]) - average;
		
		if(probabilities[more] >= 1.0 / probabilities.size()):
			large.append(more);
		else:
			small.append(more);
	
	while(!small.is_empty()):
		probability[small.pop_back()] = 1.0;
	while(!large.is_empty()):
		probability[large.pop_back()] = 1.0;

# O(1) time complexity.
func next() -> int:
	randomize();
	var column: int = randi_range(0, probability.size() - 1);
	var coinToss: bool = randf() < probability[column];
	
	if(coinToss):
		return column;
	else:
		return alias[column];