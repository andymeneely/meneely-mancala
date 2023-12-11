extends Node2D

@export var pits : Array[int] = [
	4,4,4, 4,4,4, 0, # Player 1, bottom row
	4,4,4, 4,4,4, 0, # Player 2, top row
]

@export var player1_turn : bool = true

@onready var pit_spots : Array[Button] = []

func _ready():
	$RockTemplate.visible = false
	for i in 14:
		pit_spots.push_back(get_node("%Pit" + str(i)))
	_init_pits()

func _init_pits():
	for i in 14:
		for j in pits[i]:
			var rock = %RockTemplate.duplicate()
			rock.visible = true
			var rect : Button = get_node("%Pit" + str(i))
			rock.position = rand_offset()
			rect.add_child(rock)

func _on_pit_pressed(pit_num : int):
	$Label.text = "Pressed Pit: " + str(pit_num)
	var pit = pit_from_num(pit_num)
	var next_pit_num = (pit_num + 1) % 14
	var tween = create_tween()
	for rock in pit.get_children():
		rock.reparent(pit_from_num(next_pit_num))
		tween.tween_property(rock, "position", rand_offset(), 0.25)
		next_pit_num = (next_pit_num + 1) % 14
		
func pit_from_num(num : int) -> Button:
	return get_node("%Pit" + str(num))
	
func rand_offset() -> Vector2:
	return Vector2(randi_range(0,80),randi_range(0, 80))
		
