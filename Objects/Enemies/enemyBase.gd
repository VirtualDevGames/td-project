extends Node2D

class_name EnemyBase

var lifeTime = 0.0
var lifeTimeSpeed = 0.1
var maxHP = 10
var HP = maxHP
var speed = 25

@onready var hpbar = $"HP Bar"

func _ready():
	hpbar.max_value = maxHP
	hpbar.value = maxHP

func _physics_process(_delta):
	lifeTime += _delta

func get_Lifetime():
	return lifeTime

func TakeDamage(damage : int) :
	HP -= damage
	hpbar.value = HP
	if HP <= 0 :
		queue_free()

func IsAlive() :
	return HP > 0

func _on_timer_timeout():
	hpbar.value -= 1

