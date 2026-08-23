extends Node2D

@export var haggler_scene: PackedScene
@onready var haggle_zone = $"Start Haggle Session"
@onready var seller = $Seller/Sprite2D
@onready var win_lose_manager = $WinLoseManager

var screen_size
var min_items = 1
var max_items = 10

var haggler_nodes: Dictionary = {}

signal update_time(time: int)
signal update_daily_goal(daily_goal: int)
signal update_day(day: int)

func _ready() -> void:
	GlobalMusic.play_track()
	if Global.amt_in_sales >= Global.daily_goal:
		win_lose_manager.game_won()

	screen_size = get_viewport().content_scale_size
	haggler_creation()
	seller.self_modulate = Color.PURPLE
	update_daily_goal.emit(Global.daily_goal)
	update_day.emit(Global.day)

func _process(delta: float) -> void:
	if Global.time > 0:
		Global.time = max(Global.time - delta, 0.0)
		update_time.emit(ceil(Global.time))
	else:
		win_lose_manager.game_lost()
		
func _physics_process(delta: float) -> void:
	var current = Global.get_current_haggler()
	if not current.is_empty():
		var node = haggler_nodes.get(current)
		if is_instance_valid(node):
			node.global_position.x = move_toward(node.global_position.x, haggle_zone.global_position.x, 150 * delta)
			
func haggler_creation() -> void:
	if Global.hagglers.is_empty():
		create_new_hagglers(haggler_scene)
	else:
		recreate_hagglers(haggler_scene)
		
func create_new_hagglers(haggler_scene_input: PackedScene) -> void:
	for i in range(5):
		var new_haggler = haggler_scene_input.instantiate()
		var haggler_type = Global.haggler_types.pick_random()
		
		var haggler_height = new_haggler.get_node("Sprite2D").texture.get_height()
		
		var rand_item_number = randi_range(min_items, max_items)
		new_haggler.num_items = rand_item_number
		
		var rand_items = []
		for j in range(rand_item_number):
			rand_items.append(Global.sale_items.pick_random())
		
		var random_budget_amount = randi_range(100, 300)
		new_haggler.budget = random_budget_amount
		
		var random_mood = randi_range(10, 100)
		new_haggler.mood = random_mood
		
		var random_color = Color(randf(), randf(), randf(), 1.0)
		new_haggler.haggler_color = random_color
		
		var haggle_attempts = randi_range(1,3) if haggler_type.to_lower() == "amateur" else randi_range(2, 5) if haggler_type.to_lower() == "intermediate" else randi_range(3, 6)
		
		var haggler_data = Global.create_haggler(rand_item_number, random_budget_amount, random_mood, random_color, rand_items, haggler_type, haggle_attempts)
		
		var new_x = ((screen_size.x / 2) + 150) + (i * 150)
		var new_y = screen_size.y - haggler_height - 25
		new_haggler.position = Vector2(new_x, new_y)
		
		add_child(new_haggler)
		haggler_nodes[haggler_data] = new_haggler
	
func recreate_hagglers(haggler_scene_input: PackedScene) -> void:
	for i in range(Global.hagglers.size()):
		var new_haggler = haggler_scene_input.instantiate()
		var haggler_data = Global.get_haggler_by_index(i)
		
		var haggler_height = new_haggler.get_node("Sprite2D").texture.get_height()
		
		new_haggler.type = haggler_data.type
		new_haggler.num_items = haggler_data.num_items
		new_haggler.items = haggler_data.items
		new_haggler.budget = haggler_data.budget
		new_haggler.mood = haggler_data.mood
		new_haggler.haggler_color = haggler_data.color
		
		var new_x = ((screen_size.x / 2) + 150) + (i * 150)
		var new_y = screen_size.y - haggler_height - 25
		new_haggler.position = Vector2(new_x, new_y)
		
		add_child(new_haggler)
		haggler_nodes[haggler_data] = new_haggler
	
func _on_start_haggle_session_area_entered(_area: Area2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/haggling.tscn")
