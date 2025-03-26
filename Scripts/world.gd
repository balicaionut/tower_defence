extends Node3D

@onready var enemyUfo : PackedScene = preload("res://Mobs/ufo.tscn")
@onready var weaponCannon : PackedScene = preload("res://Scenes/cannon.tscn")

@onready var cameraView : Camera3D = $Camera3D
@onready var indicator : MeshInstance3D = $Indicator

var enemiesToSpown : int = 0
var canSpawn : bool = true
var inBuildMenu : bool = false
var waveOnGoing : bool = false

func _process(delta):
	handle_player_controls()
	handle_ui()
	game_manager()

func handle_player_controls() -> void:
	var spaceState : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mousePosition : Vector2 = get_viewport().get_mouse_position()
	
	var origin : Vector3 = cameraView.project_ray_origin(mousePosition)
	var end : Vector3 = origin + cameraView.project_ray_normal(mousePosition) * 100
	var ray : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	
	ray.collide_with_bodies = true
	
	var rayResult : Dictionary = spaceState.intersect_ray(ray)
	
	if not inBuildMenu:
		if rayResult.size() > 0:
			indicator.visible = true
			var collider : CollisionObject3D = rayResult.get("collider")
			indicator.global_position = collider.global_position + Vector3(0, 0.2, 0)
			
			if collider.is_in_group("Empty"):
				indicator.set_surface_override_material(0, load("res://Materials/green.tres"))
				if Input.is_action_just_pressed("interact"):
					inBuildMenu = true
			else:
				indicator.set_surface_override_material(0, load("res://Materials/red.tres"))
		else:
			indicator.visible = false

func game_manager() -> void:
	if enemiesToSpown > 0 and canSpawn:
		$SpawnTimer.start()
		
		var tempEnemy = enemyUfo.instantiate()
		$Path.add_child(tempEnemy)
		
		enemiesToSpown -= 1
		Global.enemiesAlive += 1
		
		canSpawn = false
		
	waveOnGoing = enemiesToSpown > 0

func handle_ui() -> void:
	$Map/TowerRoundSampleF/HealthBar3D.update(Global.health)
	$CanvasLayer/UI/ShopPanel.visible = inBuildMenu
	$CanvasLayer/UI/NextWaveButton.visible = not waveOnGoing
	$CanvasLayer/UI/Gold.text = "Gold: " + str(Global.money)
	$CanvasLayer/UI/Wave.text = "Wave: " + str(Global.wave)
	$CanvasLayer/UI/ShopPanel/VBoxContainer/CannonButton.text = str(Global.weaponsCost["cannon"]) + " Gold"

func _on_spawn_timer_timeout() -> void:
	canSpawn = true

func buy_tower(cost : int, scene : PackedScene) -> void:
	if Global.money >= cost:
		inBuildMenu = false
		Global.money -= cost
		var tempCannon : StaticBody3D = scene.instantiate()
		add_child(tempCannon)
		tempCannon.global_position = indicator.global_position

func _on_cannon_button_pressed() -> void:
	buy_tower(Global.weaponsCost["cannon"], weaponCannon)

func _on_cancel_button_pressed() -> void:
	inBuildMenu = false


func _on_next_wave_button_pressed() -> void:
	Global.wave += 1
	Global.enemySpeedModifier += 0.1
	Global.enemyHealthModifier += 0.1
	enemiesToSpown = Global.wave * 3
	canSpawn = true
