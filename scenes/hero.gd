extends CharacterBody2D


signal request_tracking(momentum)
signal spawn_explosion(pos)
signal spawn_hitbox(pos, orientation)
signal spawn_enemy(pos)

@export var animation: Node

@onready var _charge_timer = $ChargeTimer
@onready var _dash_timer = $DashTimer
@onready var _activation_zone = $ActivationZone/CollisionShape2D

var _momentum: float = 0
var _direction: Vector2 = Vector2(-1,-1).normalized()
var _old_direction = Vector2(0,0)
var _is_dashing = false
var _dash_charged = false
var _dash_direction:Vector2 = Vector2(0,0)

func _ready() -> void:
	_activation_zone.shape.radius = Param.ACTIVATION_RADIUS

func _physics_process(delta: float) -> void:
	_old_direction = _direction
	_direction = Vector2(0,0)
	
	if Input.is_action_pressed("ui_right"):
		_direction += Vector2(1,0)
	
	if Input.is_action_pressed("ui_left"):
		_direction += Vector2(-1,0)
		
	if Input.is_action_pressed("ui_up"):
		_direction += Vector2(0,-1)
		
	if Input.is_action_pressed("ui_down"):
		_direction += Vector2(0,1)
	_direction = _direction.normalized()
	if Input.is_action_just_pressed("Dash_attack"):
		_dash_charged = false
		_charge_timer.start(Param.CHARGING_TIME)
		
	if Input.is_action_just_released("Dash_attack"):
		_charge_timer.stop()
		
		if _dash_charged:
			_is_dashing = true
			_dash_charged = false
			_dash_direction = _direction
			_dash_timer.start(Param.DASH_DURATION)
			
			spawn_explosion.emit(position)

	if _is_dashing:
		_dash_attack(_dash_direction)
		
	else:
		_normal_movement(delta)
	move_and_slide()

func _normal_movement(delta):
	var _instant_acceleration = 0 
	var _instant_decceleration = 0
	
	for i in range(len(Param.BREAKPOINT_SPEEDS)):
		if Param.BREAKPOINT_SPEEDS[i] > _momentum:
			continue
		_instant_acceleration = Param.INSTANT_ACCELERATION[i]
		_instant_decceleration = Param.INSTANT_DECCELERATION[i]
		break
		
		
	if _direction.length() == 0:
		_momentum -= _instant_decceleration * delta
	elif velocity.dot(_direction) >= 0:
		_momentum += _instant_acceleration * delta
		if _momentum < Param.STARTING_MOMENTUM:
			_momentum = Param.STARTING_MOMENTUM

	_momentum = clamp(_momentum, 0, Param.MAX_MOMENTUM)
	
	if _momentum > Param.TRACKING_MOMENTUM:
		request_tracking.emit(_momentum)
	
	
	var _penalty = 1
	if Input.is_action_pressed("Dash_attack"):
		_penalty = (1 - Param.CHARGE_SLOWDOWN)
	
	#var _new_direction = (_direction + Param.MOVEMENT_DIRECTION_INERTIA* _old_direction).normalized()
	_direction = (_direction + Param.MOVEMENT_DIRECTION_INERTIA* _old_direction).normalized()
	velocity = _momentum * _direction * _penalty
	
# Fisica y controles
func _dash_attack(dash_direction):
	_momentum = Param.MAX_MOMENTUM
	request_tracking.emit(_momentum)
	
	var _new_direction = dash_direction 
	if dash_direction.dot(_direction) >= 0:
		_new_direction = ((dash_direction + _direction*(Param.DASH_DIRECTION_INFLUENCE))).normalized()
	velocity = _new_direction * Param.DASH_SPEED 
	
	spawn_hitbox.emit(position, velocity.normalized())


# Graficos 

var _radius =  Param.STARTING_MOMENTUM * Param.MOMENTUM_RADIUS_CONVERSION

func _process(delta: float) -> void:
	_radius = clamp(_momentum * Param.MOMENTUM_RADIUS_CONVERSION, Param.STARTING_MOMENTUM * Param.MOMENTUM_RADIUS_CONVERSION, Param.MAX_RADIUS)
	$PointLight2D.scale = Vector2(1,1)*(_radius-Param.STARTING_MOMENTUM * Param.MOMENTUM_RADIUS_CONVERSION)/(Param.MAX_RADIUS-Param.STARTING_MOMENTUM * Param.MOMENTUM_RADIUS_CONVERSION)

	var _animation_name = "idle_"

	if _momentum == 0:
		_animation_name = "idle_"
	else:
		_animation_name = "run_"
		
		#animation.play("run")

	for i in range(8):
		# Como las direcciones cardinales estan a angulos de pi/4,
		# la mas cercana esta a un angulo menor que pi/8 

		if _direction.dot(Constants.CARDINALS_VECTORS[i]) > cos(PI/8):
			animation.play(_animation_name + Constants.CARDINALS_NAMES[i])

	queue_redraw()
	
	

func _draw():
	var _color = Color.WHITE
	if _dash_charged:
		_color = Color.MEDIUM_VIOLET_RED
	draw_circle(Vector2.ZERO, _radius, _color)


func _on_charge_timer_timeout() -> void:
	_dash_charged = true


func _on_dash_timer_timeout() -> void:
	_is_dashing = false


func _on_activation_zone_area_entered(body: Node2D) -> void:
	spawn_enemy.emit(body.global_position)
	body.call_deferred("queue_free")
