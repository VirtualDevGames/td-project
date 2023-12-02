extends Node
class_name Effect_Base

@export var animation : AnimatedSprite2D
@export var effectHitBox : CollisionShape2D
@onready var effectDamage = (get_parent() as ProjectileBase).on_hit_damage

var oneFrameTimer = 0

signal despawnBullet

func _physics_process(_delta):
	OneFrameTimer()


func _ready():
	animation.animation_finished.connect(DespawnSelf)

# Triggers when animation finishes
func DespawnSelf():
	despawnBullet.emit()
	call_deferred("queue_free")

func TriggerEffect() :
	animation.visible = true
	animation.play()

# Disables the explosion hitbox after one frame
func OneFrameTimer() :
	if oneFrameTimer > 0 :
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	oneFrameTimer += 1

func _on_area_2d_area_entered(area):
	(area.get_parent() as EnemyBase).TakeDamage(effectDamage)
