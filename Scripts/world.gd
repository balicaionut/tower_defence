extends Node3D

@onready var enemyUfo : PackedScene = preload("res://Mobs/ufo.tscn")
@onready var weaponCannon : PackedScene = preload("res://Scenes/cannon.tscn")

@onready var cameraView : Camera3D = $Camera3D

var enemiesToSpown : int = 3
var canSpawn : bool = true

func _process(delta):
	handle_player_controls()
	game_manager()

func handle_player_controls() -> void:
	var spaceState : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mousePosition : Vector2 = get_viewport().get_mouse_position()
	
	var origin : Vector3 = cameraView.project_ray_origin(mousePosition)
	var end : Vector3 = origin + cameraView.project_ray_normal(mousePosition) *100
	var ray : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	
	ray.collide_with_bodies = true
	
	var rayResult : Dictionary = spaceState.intersect_ray(ray)
	
	if rayResult.size() > 0:
		var collider : CollisionObject3D = rayResult.get("collider")
		
		if collider.is_in_group("Empty"):
			if Input.is_action_just_pressed("interact"):
				var tempCannon : StaticBody3D = weaponCannon.instantiate()
				add_child(tempCannon)
				tempCannon.global_position = collider.global_position


func game_manager() -> void:
	if enemiesToSpown > 0 and canSpawn:
		$SpawnTimer.start()
		
		var tempEnemy = enemyUfo.instantiate()
		$Path.add_child(tempEnemy)
		
		enemiesToSpown -= 1
		
		canSpawn = false

func _on_spawn_timer_timeout() -> void:
	canSpawn = true
