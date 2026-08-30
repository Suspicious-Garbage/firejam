extends Node

var CARDINALS_NAMES = ["n", "ne", "e", "se", "s", "sw", "w", "nw"] 
var CARDINALS_VECTORS = [ 
	Vector2(0,-1), 
	Vector2(1,-1).normalized(), 
	Vector2(1,0), 
	Vector2(1,1).normalized(), 
	Vector2(0,1), 
	Vector2(-1,1).normalized(), 
	Vector2(-1,0), 
	Vector2(-1,-1).normalized() 
]

# TANGENTE HIPERBOLICA
func INTERPOLATE(x, min_input, max_input, min_output, max_output):
	var average_output = (max_output-min_output)/2
	var delta_input = max_input - min_input
	var delta_output = max_output - min_output
	return min_output + (tanh(-1 + 2*(x-min_input)/delta_input) +1) * delta_output/2
