extends Node

var health : int = 100
var money : int = 100
var wave : int = 0
var enemiesAlive : int = 0
var enemyHealthModifier : float = 1
var enemySpeedModifier : float = 1


var weaponsCost: Dictionary = {
	"cannon": 50,
	"blaster": 100
}

func reset_game() -> void:
	health = 100
	money = 100
	wave = 0
	enemiesAlive = 0
