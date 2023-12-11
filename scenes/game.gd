extends Node2D

@export var init_pits : Array[int] = [
	4,4,4, 4,4,4, 0, # Player 1, bottom row
	4,4,4, 4,4,4, 0, # Player 2, top row
]

@export var player1_turn : bool = true :
	set(val):
		player1_turn = val
		$Turn.text = "Player " + ("1" if player1_turn else "2") + "'s turn!"
		_enable_disable_pit_buttons()

@onready var pit_spots : Array[Button] = []

func _ready():
	$RockTemplate.visible = false
	for i in 14:
		pit_spots.push_back(get_node("%Pit" + str(i)))
	_init_pits()
	_enable_disable_pit_buttons()

func _init_pits():
	for i in 14:
		var button : Button = %Pits.get_child(i)
		button.child_order_changed.connect(func(): _on_pit_changed(i))
		for j in init_pits[i]:
			var rock = %RockTemplate.duplicate()
			rock.visible = true	
			rock.position = rand_offset()
			button.add_child(rock)

func _on_pit_pressed(pit_num : int):
	var pit = pit_from_num(pit_num)
	var next_pit_num = calc_next_pit(pit_num)
	var tween = create_tween()
	var last_rock = pit.get_children().back()
	for rock in pit.get_children():
		rock.reparent(pit_from_num(next_pit_num))
		tween.tween_property(rock, "position", rand_offset(), 0.25).set_trans(Tween.TRANS_BOUNCE)
		if player_changes(rock, last_rock, next_pit_num):
			tween.tween_callback(func(): player1_turn = not player1_turn)
		next_pit_num = calc_next_pit(next_pit_num)
		_enable_disable_pit_buttons()

func player_changes(rock, last_rock, next_pit_num):
	var changes = rock == last_rock and next_pit_num != 6 and next_pit_num != 13
	return changes

func pit_from_num(num : int) -> Button:
	return get_node("%Pit" + str(num))
	
func rand_offset() -> Vector2:
	return Vector2(randi_range(0,80),randi_range(0, 80))
		
func calc_next_pit(i):
	var new_i = (i + 1) % 14
	if player1_turn and new_i == 13:
		new_i = 0
	if not player1_turn and new_i == 6:
		new_i = 7
	return new_i

func _on_turn_pressed():
	player1_turn = not player1_turn

func _enable_disable_pit_buttons():
	for i in 14:
		var pit = %Pits.get_child(i)
		if player1_turn:
			pit.disabled = (pit.get_child_count() == 0) or i > 6
		else:
			pit.disabled = (pit.get_child_count() == 0) or i < 6

func _on_pit_changed(pit_num : int):
	pass
	#if is_inside_tree():
		#var node = %Pits.get_child(pit_num)
		#var node_label = %PitLabels.get_child(pit_num)
		#node_label.text = node.get_child_count()
