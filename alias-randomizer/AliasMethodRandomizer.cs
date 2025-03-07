using System;
using System.Collections.Generic;

public class AliasMethodRandomizer {
	private int[] alias;
	private float[] probability;

	// O(1) time complexity.
	public int next() {
		var r = new Random(Guid.NewGuid().GetHashCode());
		int column = r.Next(0, probability.Length);
		bool coinToss = r.NextDouble() < probability[column];

		return coinToss ? column : alias[column];
	}

	// O(n) time complexity, but only happens once upon initialization. Only need to re-initialize if weights (input probabilities) change.
	private void init(float[] inputProbabilities) {
		probability = new float[inputProbabilities.Length];
		alias = new int[inputProbabilities.Length];

		float average = 1.0f / inputProbabilities.Length;

		float[] probabilities = new float[inputProbabilities.Length];

		for (int i = 0; i < probabilities.Length; i++) {
			probabilities[i] = inputProbabilities[i];
		}

		Stack<int> small = [];
		Stack<int> large = [];

		for (int i = 0; i < probabilities.Length; i++) {
			if (probabilities[i] >= average) {
				large.Push(i);
			} else {
				small.Push(i);
			}
		}

		while (small.Count != 0 && large.Count != 0) {
			int less = small.Pop();
			int more = large.Pop();

			probability[less] = probabilities[less] * probabilities.Length;
			alias[less] = more;

			probabilities[more] = (probabilities[more] + probabilities[less]) - average;

			if (probabilities[more] >= 1.0f / probabilities.Length) {
				large.Push(more);
			} else {
				small.Push(more);
			}
		}

		while (small.Count != 0) {
			probability[small.Pop()] = 1.0f;
		}

		while (large.Count != 0) {
			probability[large.Pop()] = 1.0f;
		}
	}
}