extends ParallaxBackground

@export var TextureRecs : Array[TextureRect]
@export var ImageSet1 : Array[CompressedTexture2D]
@export var ImageSet2 : Array[CompressedTexture2D]
@export var ImageSet3 : Array[CompressedTexture2D]
@export var ImageSet4 : Array[CompressedTexture2D]
@export var ImageSet5 : Array[CompressedTexture2D]
@onready var AllImageSets : Array = [ImageSet1, ImageSet2, ImageSet3, ImageSet4, ImageSet5]

func _ready():
	# Pick a random image set and apply them to the texture recs
	var randint = RandomNumberGenerator.new().randi_range(0, 4)
	for i in AllImageSets[randint].size() :
		TextureRecs[i].texture = AllImageSets[randint][i]

func _process(delta):
	scroll_offset.x -= 40 * delta
