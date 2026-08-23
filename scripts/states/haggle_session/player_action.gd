extends State
class_name PlayerAction

var haggle_manager: HagglingManager:
	get: return manager as HagglingManager

signal player_haggle_offer(amt)

func Enter(): 
	haggle_manager.make_offer_button.disabled = false
	haggle_manager.accept_offer_button.disabled = false
	haggle_manager.refuse_offer_button.disabled = false
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func PhysicsUpdate(_delta: float):
	pass

func accept_offer() -> void:
	Global.remove_haggler()
	Global.amt_in_sales += haggle_manager.current_offer
	get_tree().call_deferred("change_scene_to_file", "res://scenes/entrance.tscn")
	
func refuse_offer() -> void:
	Global.remove_haggler()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/entrance.tscn")
	
func make_offer() -> void:
	var player_offer = haggle_manager.player_offer_input.text
	if player_offer.strip_edges() == "":
		return
		
	haggle_manager.player_offer_input.clear()
	haggle_manager.player_offer_input.grab_focus()
	
	player_haggle_offer.emit(int(player_offer))
	state_transition.emit(self, "haggleraction")
