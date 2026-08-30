quehaceres
	programacion
		enemigos
		terminar dash
		visualizacion carga fuego
		balas
		implementar sonido
	diseño
		cuerpos que se queman/checkpoint
		enemigos
		tunear numeros movimiento y dash
		items/recompensa/aLGO
	arte
		mapa
			texturar piso
			agregar random piedras faltantes
			remover tiles placeholder
			cambiar color path


var _animation_name = "idle"

	if _momentum == 0:
		_animation_name = "idle"
	else:
		_animation_name = "run"
		
		animation.play("run")
	
	for i in range(8):
		if _direction == Constants.CARDINALS_VECTORS[i]:
			animation.play(_animation_name + Constants.CARDINALS_NAMES[i])



extends Node

var CARDINALS_NAMES = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
var CARDINALS_VECTORS = [
	Vector2(0,-1), Vector2(1,-1).normalized(), Vector2(1,0), Vector2(1,1).normalized(),
	Vector2(0,1), Vector2(-1,1).normalized(), Vector2(-1,0), Vector2(-1,-1).normalized()
]
