extends FSM
class_name HagglingManager

@onready var haggler_budget_label  = $"../Haggle Stats/VBoxContainer/Panel/VBoxContainer2/VBoxContainer/Budget"
@onready var current_total_label  = $"../Haggle Stats/VBoxContainer/Panel/VBoxContainer2/VBoxContainer/Total"
@onready var list = $"../Haggle Items/VBoxContainer/VBoxContainer/ScrollContainer/List"
@onready var time = $"../Time/VBoxContainer/Panel/VBoxContainer2/VBoxContainer/Time"
@onready var player_offer_input = $"../Haggling Options/HBoxContainer/Haggle/MarginContainer/HBoxContainer/LineEdit"
@onready var seller_sprite = $"../Seller/Sprite2D2"
@onready var make_offer_button = $"../Haggling Options/HBoxContainer/Haggle/MarginContainer/HBoxContainer/Button2"
@onready var accept_offer_button = $"../Haggling Options/HBoxContainer/Finalize Deal/MarginContainer/Button"
@onready var refuse_offer_button = $"../Haggling Options/HBoxContainer/Refused Deal/MarginContainer/Button"
@onready var counter_offer = $"../Haggling Options/HBoxContainer2/VBoxContainer/Panel/Label"
@onready var win_lose_manager = $"../WinLoseManager"

@export var haggler_scene: PackedScene
@export var item_scene: PackedScene


var current_total = 0
var current_offer = 0
var screen_size
var haggler
var disable_player_input = true

func _ready() -> void:
	super()
	screen_size = get_parent().get_viewport().size
	var haggler_data = Global.get_current_haggler()
	haggler_budget_label.text = "Haggler Budget: $%d" % haggler_data.budget
	current_total_label.text = "Current Total: $%d" % current_total
	seller_sprite.self_modulate = Color.PURPLE
	counter_offer.text = "Counter Offer: $0"
	add_haggler()
	populate_item_list()

func _process(delta: float) -> void:
	if Global.time > 0:
		Global.time = max(Global.time - delta, 0.0)
		time.text = "Time: %s" % str(ceil(Global.time))
	else:
		win_lose_manager.game_lost()

func add_haggler() -> void:
	haggler = haggler_scene.instantiate()
	var haggler_data = Global.get_current_haggler()
	
	haggler.type = haggler_data.type
	haggler.num_items = haggler_data.num_items
	haggler.items = haggler_data.items
	haggler.budget = haggler_data.budget
	haggler.mood = haggler_data.mood
	haggler.haggler_color = haggler_data.color
	haggler.sprite_frame = 0
	haggler.sprite_scale = Vector2(5, 5)
	
	haggler.get_node("Haggler Stats").hide()
	
	var new_x = screen_size.x / 2 + 50
	var new_y = (screen_size.y / 2) - 50
	
	haggler.position = Vector2(new_x, new_y)
	haggler.z_index = -1
	
	get_parent().add_child.call_deferred(haggler)

func populate_item_list() -> void:
	var haggler_data = Global.get_current_haggler()
	var amt = 0
	for i in range(haggler_data.num_items):
		var item = item_scene.instantiate()
		item.item_name = haggler_data.items[i].name
		item.item_description = haggler_data.items[i].description
		item.item_starting_price = haggler_data.items[i].starting_price
		amt += item.item_starting_price 
		list.add_child(item)
		
	current_total = amt
	current_total_label.text = "Current Total: $%d" % amt
		
func update_offer(amt: Variant) -> void:
	current_offer = amt
	
func _on_player_action_player_haggle_offer(amt: Variant) -> void:
	counter_offer.text = "Counter Offer: $%d" %amt
