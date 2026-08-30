extends Node


### Movimiento

# Curva de aceleraciones (y desaceleraciones)
# en funcion de la velocidad
var BREAKPOINT_SPEEDS = [0] 
var INSTANT_ACCELERATION = [420] 
var INSTANT_DECCELERATION = [500]

var STARTING_MOMENTUM: float = 200
var MAX_MOMENTUM: float = 500

# El "peso" de la direccion anterior sobre la nueva
# Si es 1, tiene la misma influencia que el input
var MOVEMENT_DIRECTION_INERTIA: float = 5

# Dash
# Los tiempos estan en segundos
var CHARGING_TIME:float = 2 
var DASH_DURATION:float = 1

var DASH_SPEED = 800

# El "peso" del input sobre la direccion del dash
# Si es 1, tiene la misma influencia que la original
var DASH_DIRECTION_INFLUENCE: float = 0.4


## Camara
# A que velocidad la camara empieza a adelantarse
var TRACKING_MOMENTUM: float = 220


## Aura

var MAX_RADIUS: float = 500
var MOMENTUM_RADIUS_CONVERSION: float = 0.3
