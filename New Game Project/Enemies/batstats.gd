extends Node

signal zero_health
signal health_changed(value)
@export var max_health= 1
@onready var health = max_health:
	set = set_health

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("zero_health")
