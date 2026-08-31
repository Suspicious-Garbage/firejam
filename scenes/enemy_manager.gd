extends Node2D

var monster = preload("monster.tscn")
var bullet = preload("bullet.tscn")

var enemy_queue =  []
var bullet_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while enemy_queue.size() > Param.ENEMY_CAP:
		var _despawned_enemy = enemy_queue.pop_front()
		_despawned_enemy.queue_free()
		
	while bullet_queue.size() > Param.BULLET_CAP:
		var _despawned_bullet = bullet_queue.pop_front()
		_despawned_bullet.queue_free()


func _on_monster_fired(pos, vel):
		var new_bullet = bullet.instantiate()
		new_bullet.position = pos
		new_bullet.velocity = vel
		
		new_bullet.collided.connect(_on_bullet_collided)
		
		add_child(new_bullet)
		bullet_queue.push_back(new_bullet)

func _on_enemy_died(enemy):
	enemy_queue.erase(enemy)
	enemy.queue_free()
	
func _on_bullet_collided(bullet):
	bullet_queue.erase(bullet)
	bullet.queue_free()

func _spawn_enemy(enemy):
	var new_enemy
	
	new_enemy = monster.instantiate()
	new_enemy._type = enemy.type
		
	
	new_enemy.fired.connect(_on_monster_fired)
	
	new_enemy.global_position = enemy.global_position
	new_enemy.died.connect(_on_enemy_died)
	
	add_child.call_deferred(new_enemy)
	enemy_queue.push_back(new_enemy)
