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
var _type = "plant"

func _process(delta: float) -> void:
	match _type:
		"plant":
			plant_graphics()
		"flower":
			flower_graphics()
		"fungus":
			fungus_graphics()
	
func _ready():
	_state_timer.timeout.connect(_state_transition)
	_shoot_timer.timeout.connect(_on_shoot_timer)
	_state_transition()

func _state_transition() -> void:
	_in_range = false
	var _targets = _detection_range.get_overlapping_bodies()
	
	_state_timer.start(1)
	
	if _targets.size() != 0:
		_player = _targets[0]
		_in_range = true
	
	match _type:
		"plant":
			plant_ai()
		"flower":
			flower_ai()
		"fungus":
			fungus_ai()
			
#func _physics_process(delta: float) -> void:


func _on_shoot_timer():
	if _shots.size() > 0:
		var shots = _shots.pop_front()
		for params in shots:
			fired.emit(params[0], params[1] * 200)
	else:
		_shoot_timer.stop()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	died.emit(self)
	

#------------------------------


func plant_ai():
	if _in_range:
		match _state:
			0: 
				_direction = (_player.position - position).normalized()
				
				_shoot_timer.start(0.1)
				_shots = [
					[[position, _direction]],
					[[position, _direction]],
					[[position, _direction]],
					[[position, _direction]],
					[[position, _direction]]
				]
				_state = 1
			1:
				_state = 0	
				
func plant_graphics():
	$AnimatedSprite2D.play("plant_idle")

# ---

func flower_ai():
	if _in_range:
		match _state:
			0: 
				_direction = (_player.position - position).normalized()
				$ShootTimer.start(0.1)
				for i in range(4):
					_shots.push_back(
						[
							[position, _direction.rotated(PI/16 * i)],
							[position, _direction.rotated(-1 * PI/16 * i)]
						]
					)
			1:
				_state = 0

func flower_graphics():
	$AnimatedSprite2D.play("flower_idle")

#---
				
func fungus_ai():
	if _in_range:
		_direction = (_player.position - position).normalized()
		match _state:
			0: 
				$ShootTimer.start(0.1)
				var volley = []
				for dir in Constants.CARDINALS_VECTORS:
					volley.push_back([position, dir])
				_shots = [volley]
				_state = 1
			1:
				$ShootTimer.start(0.1)
				var volley = []
				for dir in Constants.CARDINALS_VECTORS:
					volley.push_back([position, dir.rotated(PI/8)])
				_shots = [volley]
				_state = 0

func fungus_graphics():
	$AnimatedSprite2D.play("fungus_idle")
