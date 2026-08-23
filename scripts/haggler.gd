extends Area2D

@onready var items_label = $"Haggler Stats/Items"
@onready var budget_label = $"Haggler Stats/Budget"
@onready var mood_progress_bar = $Mood
@onready var haggler_sprite = $Sprite2D

var num_items = 0
var budget = 0
var items = []
var mood = 0
var haggler_color
var type
var sprite_frame = 2
var sprite_scale = Vector2(4, 4)

func _ready() -> void:
	
	haggler_sprite.scale = sprite_scale
	haggler_sprite.frame = sprite_frame
	haggler_sprite.self_modulate = haggler_color
	
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = (Color.RED if mood <= 20 else (Color.YELLOW if mood <= 60 and mood > 20 else Color.GREEN)) 
	
	mood_progress_bar.add_theme_stylebox_override("fill", new_stylebox)
	
	items_label.text = "%d Items" % [num_items] if num_items else "999999 Items"
	budget_label.text = "Budget: $%d " % [budget] if budget else "Budget: $99999999"
	
	mood_progress_bar.value = mood
