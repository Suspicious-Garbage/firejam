extends Camera2D	

var _deviation = Vector2(0,0)
var _zoom_level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = _deviation
	zoom = Vector2(1,1)/_zoom_level
	_deviation = Vector2(0,0)
	_zoom_level = 1	

func _on_hero_request_tracking(momentum) -> void:
	_deviation = get_parent().velocity * 1/2
	_zoom_level = Constants.INTERPOLATE(momentum, Param.TRACKING_MOMENTUM, Param.MAX_MOMENTUM, 1, 2)

func _on_timer_timeout() -> void:
	return
