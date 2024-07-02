var weights: Array[int] = [5, 30, 65];

func create_probabilities_from_weights(weights: Array[int]) -> Array[float]:
	var result: Array[float];
	result.resize(weights.size());
	var total_weight: float = sum(weights);
	
	for i in result.size():
		result[i] = weights[i] / total_weight;
	
	return result;

func sum(array: Array[int]) -> int:
	var sum: int = 0;
	for item in array:
		sum += item;
	return sum;

var input: Array[float] = create_probabilities_from_weights(weights);
var rand: AliasMethodRandomizer = AliasMethodRandomizer.new(input);

# Prints out the index of the corresponding weight. For example, 0 corresponds to 5, 1 corresponds to 30, etc.
func run() -> void:
	print(rand.next());