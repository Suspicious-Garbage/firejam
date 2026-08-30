extends Node2D

var explosion = preload("explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_explosion(pos: Variant) -> void:
	var new_explosion = explosion.instantiate()
	new_explosion.position = pos
	
	add_child(new_explosion)
