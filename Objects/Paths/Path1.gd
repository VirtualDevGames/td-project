extends Path2D

class_name EnemyPath

var pathSpeed : float = 0.0
@onready var pathFollowNode : PathFollow2D = $PathFollow2D

func _physics_process(delta) :
	pathFollowNode.set_progress(pathFollowNode.get_progress() + pathSpeed * delta)
	if pathFollowNode.progress_ratio == 1 :
		queue_free()
