extends StaticBody3D

var bullet : PackedScene = preload("res://Scenes/bullet.tscn")
var bulletDamage : int = 1
var currentTargets : Array = []
var current : CharacterBody3D
var canShoot : bool = true

func _process(delta):
	if is_instance_valid(current):
		look_at(current.global_position)
		if canShoot:
			shoot()
			canShoot = false
			$ShootingCoolDown.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func shoot() -> void:
	var tempBullet : CharacterBody3D = bullet.instantiate()
	tempBullet.target = current
	tempBullet.bulletDamage = bulletDamage
	get_node("BulletContainer").add_child(tempBullet)
	tempBullet.global_position = $MeshInstance3D/Aim.global_position

func choose_target(_currentTargets : Array) -> void:
	var tempArray : Array = _currentTargets
	var currentTarget : CharacterBody3D = null
	for i in tempArray:
		if currentTarget == null:
			currentTarget = i
		else:
			if i.get_parent().get_progress() > currentTarget.get_parent().get_progress():
				currentTarget = i
	
	current = currentTarget

func _on_mob_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		currentTargets.append(body)
		choose_target(currentTargets)

func _on_mob_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		currentTargets.erase(body)
		choose_target(currentTargets)

func _on_shooting_cool_down_timeout() -> void:
	canShoot = true
