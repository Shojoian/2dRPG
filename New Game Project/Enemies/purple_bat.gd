extends CharacterBody2D

const BatDeathEffect = preload("res://Effects/BatDeathEffect.tscn")

@export var MAX_SPEED = 50
@export var ACCELERATION = 75
@export var FRICTION = 15

enum{
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var state = CHASE
@onready var sprite = $AnimatedSprite2D
@onready var stats = $BatStats
@onready var PDZ = $PlayerDetectionZone
@onready var hb = $Hurtbox
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var Player = PDZ.Player
			if Player != null:
				var direction = (Player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	move_and_slide()
			
func seek_player():
	if PDZ.can_see_player():
		state = CHASE
		

func _on_hurtbox_area_entered(area):
	stats.max_health -= area.damage
	velocity = area.knockback_vector * 25
	hb.create_hit_effect()

func _on_bat_stats_zero_health():
	queue_free()
	var batDeathEffect = BatDeathEffect.instantiate()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.global_position = global_position
