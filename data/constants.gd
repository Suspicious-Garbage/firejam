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
