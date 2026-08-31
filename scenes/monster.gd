extends CharacterBody2D

signal fired(bullet)
signal died(id)
	
@onready var _detection_range = $DetectionRange
@onready var _state_timer = $StateTimer
@onready var _shoot_timer = $ShootTimer



var _state = 0
var _direction: Vector2
var _player: Node
var _in_range: bool = false
var _counter: int = 0
var _shots = []

func _process(delta: float) -> void:
	pass
	
func _ready():
	_state_timer.timeout.connect(_state_transition)
	_shoot_timer.timeout.connect(_on_shoot_timer)
	_state_transition()

func _state_transition() -> void:
	_in_range = false
	var _targets = _detection_range.get_overlapping_bodies()
	
	
	if _targets.size() != 0:
		_player = _targets[0]
		_in_range = true
	
		match _state:
			0: 
				_direction = (_targets[0].position - position).normalized()
				$ShootTimer.start(0.1)
				_shots = [
					[_direction, position],
					[_direction, position],
					[_direction, position],
					[_direction, position],
					[_direction, position]
				]
				_state = 1
			1:
				_state = 0	
	_state_timer.start(1)
	
#func _physics_process(delta: float) -> void:

func _on_shoot_timer():
	if _shots.size() > 0:
		var params = _shots.pop_front()
		fired.emit(params[1], params[0] * 200)
	else:
		_shoot_timer.stop()
		state_transition()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	died.emit(self)
	





func state_transition() -> void:
	pass # Replace with function body.
