extends CharacterBody2D

signal fired(bullet)
signal died(id)
	
@onready var _detection_range = $DetectionRange

var is_dead = false

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_text_backspace"):
		fired.emit(position, Vector2(-200,0))


func _on_timer_timeout() -> void:
	var _targets = _detection_range.get_overlapping_bodies()

	if _targets.size() == 0:
		return
	
	var _player = _targets[0]
	
	var _direction = (_player.position - position).normalized()
	
	fired.emit(position, _direction * 200)



func _on_hurtbox_area_entered(area: Area2D) -> void:
	died.emit(self)
