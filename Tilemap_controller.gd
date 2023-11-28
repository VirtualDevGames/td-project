extends TileMap

const main_layer = 0
const main_atlas_id = 0

var turretNode = preload("res://Objects/Scripts and Scenes/Towers/towerBase.tscn")
var enemyNode = preload("res://Objects/Scripts and Scenes/Enemies/enemyBase.tscn")

var nodeToSpawn = preload("res://Objects/Scripts and Scenes/Towers/towerBase.tscn")

var path = preload("res://Objects/Scripts and Scenes/Paths/Path1.tscn")

@onready var enemySpawnPoint = $EnemySpawnPoint


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			nodeToSpawn = turretNode
			SpawnTurret(get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			SpawnEnemy()
			#for turrs in get_children() :
				#if turrs is TowerBase :
					#print("a")
					#turrs.queue_free()
	

func SpawnTurret(_position):
	var spawnInstance = nodeToSpawn.instantiate()
	spawnInstance.position = _position
	add_child(spawnInstance)

func SpawnEnemy() :
	var spawnInstancePath = path.instantiate()
	add_child(spawnInstancePath)
	spawnInstancePath.position = enemySpawnPoint.position
	var spawnInstanceEnemy = enemyNode.instantiate()
	spawnInstancePath.get_child(0).add_child(spawnInstanceEnemy)
	(spawnInstancePath as EnemyPath).pathSpeed = (spawnInstanceEnemy as EnemyBase).speed
