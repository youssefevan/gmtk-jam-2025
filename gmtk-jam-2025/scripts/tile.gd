extends Node2D
class_name Tile

var type := "card"

var tiles = {
	"card": 0,
	"chance": 1,
	"enemy": 2,
}

func _ready():
	$Sprite.frame = tiles[type]
