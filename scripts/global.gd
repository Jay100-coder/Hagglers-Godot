extends Node

var haggler_types = ["Amateur", "Intermediate", "Expert"]
var hagglers = []
var sale_items = [
	{
		"name": "Vintage Film Camera",
		"description": "35mm SLR, needs film.",
		"starting_price": 30
	},
	{
		"name": "Mismatched Board Game",
		"description": "Classic box, missing a few pieces.",
		"starting_price": 10
	},
	{
		"name": "Retro Lava Lamp",
		"description": "Red wax, takes time to warm up.",
		"starting_price": 15
	},
	{
		"name": "Slightly Scuffed Acoustic Guitar",
		"description": "Nylon strings, missing high E.",
		"starting_price": 50
	},
	{
		"name": "Cast Iron Skillet",
		"description": "Heavy, well-seasoned, ready to use.",
		"starting_price": 45
	}
]
var amt_in_sales = 0
var daily_goal = 500
var day = 1
var time = 120

func create_haggler(num_items: int, budget: int, mood: int, color: Color, items: Array, type: String, attempts: int) -> Dictionary:
	var data = {
		"type": type,
		"num_items": num_items,
		"budget": budget,
		"mood": mood,
		"color": color,
		"items": items,
		"attempts": attempts
	}
	hagglers.append(data)
	return data  

func get_haggler_by_index(index: int) -> Dictionary:
	return hagglers[index]
	
func get_current_haggler() -> Dictionary:
	return hagglers[0]

func remove_haggler() -> void:
	hagglers.remove_at(0)
