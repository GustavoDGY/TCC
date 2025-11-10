extends Area2D

@export var blue_rooms := [
	"res://Rooms/room1.tscn",
	"res://Rooms/room2.tscn",
	"res://Rooms/room3.tscn",
	"res://Rooms/room4.tscn",
    "res://Rooms/room5.tscn"
]

@export var red_rooms := [
	"res://Rooms/room6.tscn",
	"res://Rooms/room7.tscn",
	"res://Rooms/room8.tscn",
	"res://Rooms/room9.tscn",
    "res://Rooms/room10.tscn"
]

var count_rooms = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		var rng = RandomNumberGenerator.new()
		var random_room
		if count_rooms < 5:
			random_room = blue_rooms[rng.randi_range(0, blue_rooms.size() - 1)]
		else:
			random_room = red_rooms[rng.randi_range(0, red_rooms.size() - 1)]
		get_tree().change_scene_to_file(random_room)
		count_rooms += 1
