extends State
class_name HagglerAction

var haggle_manager: HagglingManager:
	get: return manager as HagglingManager
var haggler_data = Global.get_current_haggler()
var haggle_attempts
signal haggle_offer(amt)

func Enter():
	haggle_manager.make_offer_button.disabled = true
	haggle_manager.accept_offer_button.disabled = true
	haggle_manager.refuse_offer_button.disabled = true
	
	if not haggle_attempts and haggle_manager.current_offer == 0:
		haggle_attempts = haggler_data.attempts
	
	await get_tree().create_timer(2).timeout
	
	if haggle_manager.current_offer == 0 and haggle_attempts != 0:
		make_initial_offer()
	elif haggle_manager.current_offer > 0 and haggle_attempts != 0:
		make_haggle_offer()
	elif haggle_attempts <= 0:
		finalize_offer()
		
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func PhysicsUpdate(_delta: float):
	pass

func update_haggle_response(update_str: String):
	var response_node = haggle_manager.haggler.get_node("Response")
	var text_node = response_node.get_node("RichTextLabel")
	
	text_node.text = update_str
	response_node.show()
	
func reject_offer():
	update_haggle_response("Sorry Not Interested")
	await get_tree().create_timer(2).timeout
	Global.remove_haggler()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/entrance.tscn")
	
func accept_offer():
	update_haggle_response("I Will Accept Your Offer")
	await get_tree().create_timer(2).timeout
	Global.remove_haggler()
	Global.amt_in_sales += haggle_manager.current_offer
	get_tree().call_deferred("change_scene_to_file", "res://scenes/entrance.tscn")

func make_amateur_offer():
	var mood_multiplier = (randf_range(0.05, 0.1) if haggler_data.mood >= 60 else (randf_range(-0.05, -0.1) if haggler_data.mood <= 20 else 0.0))
	if haggle_manager.current_total > haggler_data.budget:
		var offer = haggler_data.budget * randf_range(0.95, 1)
		var final_offer = offer
		haggle_attempts -= 1
		update_haggle_response("Can you do $%d ?" % final_offer)
		haggle_offer.emit(final_offer)
	else:
		var offer = haggle_manager.current_total * randf_range(0.95, 1)
		var final_offer = offer + (offer * mood_multiplier)
		haggle_attempts -= 1
		haggle_offer.emit(final_offer if final_offer < haggler_data.budget else haggler_data.budget)
		update_haggle_response("Can you do $%d ?" % final_offer)
	state_transition.emit(self, "playeraction")
	
func make_intermediate_offer():
	var mood_multiplier = (randf_range(0.05, 0.1) if haggler_data.mood >= 60 else (randf_range(-0.05, -0.1) if haggler_data.mood <= 20 else 0.0))
	if haggle_manager.current_total > haggler_data.budget:
		var offer = haggler_data.budget * randf_range(0.85, 0.95)
		var final_offer = offer
		haggle_attempts -= 1
		update_haggle_response("Can you do $%d ?" % final_offer)
		haggle_offer.emit(final_offer)
	else:
		var offer = haggle_manager.current_total * randf_range(0.85, 0.95)
		var final_offer = offer + (offer * mood_multiplier)
		haggle_attempts -= 1
		update_haggle_response("Can you do $%d ?" % final_offer)
		haggle_offer.emit(final_offer if final_offer < haggler_data.budget else haggler_data.budget)
	state_transition.emit(self, "playeraction")
	
func make_expert_offer():
	var mood_multiplier = (randf_range(0.05, 0.1) if haggler_data.mood >= 60 else (randf_range(-0.05, -0.1) if haggler_data.mood <= 20 else 0.0))
	if haggle_manager.current_total > haggler_data.budget:
		var offer = haggler_data.budget * randf_range(0.6, 0.80)
		var final_offer = offer
		haggle_attempts -= 1
		update_haggle_response("Can you do $%d ?" % final_offer)
		haggle_offer.emit(final_offer)
	else:
		var offer = haggle_manager.current_total * randf_range(0.6, 0.80)
		var final_offer = offer + (offer * mood_multiplier)
		haggle_attempts -= 1
		update_haggle_response("Can you do $%d ?" % final_offer)
		haggle_offer.emit(final_offer if final_offer < haggler_data.budget else haggler_data.budget)
	state_transition.emit(self, "playeraction")
	
func make_initial_offer():
	if haggler_data.type.to_lower() == "amateur":
		make_amateur_offer()
	elif haggler_data.type.to_lower() == "intermediate":
		make_intermediate_offer()
	else:
		make_expert_offer()
	
func make_haggle_offer():
	var should_accept
	
	if haggler_data.type.to_lower() == "amateur":
		should_accept = randi_range(1, 10) <= 9 and haggle_manager.current_offer <= haggler_data.budget
		if should_accept:
			accept_offer()
		else:
			make_amateur_offer()
			
	elif haggler_data.type.to_lower() == "intermediate":
		should_accept = randi_range(1, 10) <= 7.5 and haggle_manager.current_offer <= haggler_data.budget
		if should_accept:
			accept_offer()
		else:
			make_intermediate_offer()
	else:
		should_accept = randi_range(1, 10) <= 6.5 and haggle_manager.current_offer <= haggler_data.budget
		if should_accept:
			accept_offer()
		else:
			make_expert_offer()

func finalize_offer():
	var should_accept
	
	if haggler_data.type.to_lower() == "amateur":
		should_accept = randi_range(1, 10) <= 8 and haggle_manager.current_offer <= haggler_data.budget
		
		if should_accept:
			accept_offer()
		else:
			reject_offer()
			
	elif haggler_data.type.to_lower() == "intermediate":
		should_accept = randi_range(1, 10) <= 7 and haggle_manager.current_offer <= haggler_data.budget
		if should_accept:
			accept_offer()
		else:
			reject_offer()
		
	else:
		should_accept = randi_range(1, 10) <= 6 and haggle_manager.current_offer <= haggler_data.budget
		if should_accept:
			accept_offer()
		else:
			reject_offer()
