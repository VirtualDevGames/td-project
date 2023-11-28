extends AnimatedSprite2D

class_name ProjectileOnHitVFX
@export var projectileBase : ProjectileBase

func _ready():
	pass

func PlayAnimation() :
	visible = true
	match projectileBase.onHitType :
		OnHitTypes.Types.Explosive :
			play("RingExplosion")
		OnHitTypes.Types.CloudExplosion :	
			play("CloudExplosion")

