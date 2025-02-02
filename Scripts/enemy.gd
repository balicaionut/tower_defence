extends CharacterBody3D

@export var speed : int = 2
@export var health : int = 2

@onready var Path : PathFollow3D = get_parent()


func _physics_process(delta: float) -> void:
	Path.set_progress(Path.get_progress() + speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Global.health -= 20
		death()

func take_damage(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		Global.money += 50
		death()

func death() -> void:
	Global.enemiesAlive -= 1
	Path.queue_free()
