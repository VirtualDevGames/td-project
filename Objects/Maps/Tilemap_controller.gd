extends TileMap

class_name WorldMap

const main_layer = 0
const main_atlas_id = 0

var turretNode = preload("res://Objects/Towers/towerBase.tscn")
var enemyNode = preload("res://Objects/Enemies/enemyBase.tscn")

var nodeToSpawn = preload("res://Objects/Towers/Cappo Tower.tscn")

var path = preload("res://Objects/Paths/Path1.tscn")

var can_place_turrets = true

var ground_layer = 0
var decoration_layer_A = 1
var decoration_layer_B = 2
var building_layer = 3
var invisible_tile_atlas_coords = Vector2(12,1)

@onready var enemySpawnPoint = $EnemySpawnPoint

func _process(_delta):
	if Input.is_action_just_pressed("Spacebar") :
		can_place_turrets = !can_place_turrets

func _input(event):
	if Input.is_action_just_pressed("M1"):
			if can_place_turrets:
				var tile_mouse_pos : Vector2i = local_to_map(get_local_mouse_position())
				var tile_data_bottom_layer : TileData = \
									get_cell_tile_data(ground_layer,tile_mouse_pos)
				var tile_data_building_layer : TileData = \
									get_cell_tile_data(building_layer,tile_mouse_pos)
				var tile_data_decoration_layer : TileData = \
									get_cell_tile_data(decoration_layer_A, tile_mouse_pos)
				if tile_data_bottom_layer && tile_data_bottom_layer.get_custom_data("Buildable") :
					if !tile_data_building_layer : # If not building layer has tile
						if tile_data_decoration_layer :
							if tile_data_decoration_layer.get_custom_data("Buildable") :
								set_cell(building_layer, tile_mouse_pos, 0, invisible_tile_atlas_coords)
								SpawnTurret(map_to_local(tile_mouse_pos))
						else :
							set_cell(building_layer, tile_mouse_pos, 0, invisible_tile_atlas_coords)
							SpawnTurret(map_to_local(tile_mouse_pos))
	
	elif Input.is_action_just_pressed("M2"):
			SpawnEnemy()

func SpawnTurret(_position):
	var spawnInstance = nodeToSpawn.instantiate()
	spawnInstance.global_position = _position
	add_child(spawnInstance)
	UiSignals.add_tower.emit(spawnInstance, 1)

func SpawnEnemy() :
	var spawnInstancePath = path.instantiate()
	add_child(spawnInstancePath)
	spawnInstancePath.position = enemySpawnPoint.position
	var spawnInstanceEnemy = enemyNode.instantiate()
	spawnInstancePath.get_child(0).add_child(spawnInstanceEnemy)
	(spawnInstancePath as EnemyPath).pathSpeed = (spawnInstanceEnemy as EnemyBase).speed
