extends Node

var health : int = 100
var money : int = 250
var wave : int = 0
var enemiesAlive : int = 0

func reset_game() -> void:
	health = 100
	money = 250
	wave = 0
	enemiesAlive = 0
