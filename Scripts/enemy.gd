extends CharacterBody3D

@export var speed : float = 2 * Global.enemySpeedModifier
@export var health : float = 2 * Global.enemyHealthModifier

@onready var Path : PathFollow3D = get_parent()

func _ready():
	$HealthBar3D.set_up(health)

func _physics_process(delta: float) -> void:
	Path.set_progress(Path.get_progress() + speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Global.health -= 20
		death()

func take_damage(damage : int) -> void:
	health -= damage
	$HealthBar3D.update(health)
	
	if health <= 0:
		Global.money += 50
		death()

func death() -> void:
	Global.enemiesAlive -= 1
	Path.queue_free()
