extends Node2D

var explosion = preload("explosion.tscn")
var hitbox = preload("res://scenes/hitbox.tscn")

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


func _on_hero_spawn_hitbox(pos: Variant, orientation: Variant) -> void:
	var new_hitbox = hitbox.instantiate()
	new_hitbox.position = pos
	new_hitbox.rotation = acos(orientation[0]) * sign(orientation[1])
	new_hitbox.set_collision_layer_value(2, true)
	add_child(new_hitbox)
