extends AnimatedSprite2D

class_name ProjectileOnHitVFX
@export var projectileBase : ProjectileBase

func _ready():
	pass

func PlayAnimation() :
	visible = true
	play(str(projectileBase.onHitType))

