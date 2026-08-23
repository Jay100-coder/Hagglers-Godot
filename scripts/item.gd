extends VBoxContainer

@onready var name_label = $MarginContainer/VBoxContainer/Name
@onready var description_label = $MarginContainer/VBoxContainer/Description
@onready var starting_price_label = $"MarginContainer/VBoxContainer/Starting Price"

var item_name
var item_description
var item_starting_price = 0

func _ready() -> void:
	name_label.text = "Failed to fetch Name" if not item_name else "Name: %s" % item_name
	description_label.text = "Failed to fetch Description" if not item_description else "Description: %s" % item_description
	starting_price_label.text = "Failed to fetch Starting Price" if not item_starting_price else "Price: $%d" % item_starting_price
