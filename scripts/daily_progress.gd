extends CanvasLayer

@onready var days = $HBoxContainer/VBoxContainer/Day
@onready var money_goal = $HBoxContainer/VBoxContainer/Goal
@onready var time = $HBoxContainer/VBoxContainer/Time

func _ready() -> void:
	days.text = "Day: %d" % Global.day
	money_goal.text = "Goal: $%d / $%d" % [Global.amt_in_sales, Global.daily_goal]

func _on_entrance_update_time(new_time: int) -> void:
	time.text = "Time: %s" % str(ceil(new_time))


func _on_entrance_update_day(day: int) -> void:
	days.text = "Day: %d" % day


func _on_entrance_update_daily_goal(daily_goal: int) -> void:
	money_goal.text = "Goal: $%d / $%d" % [Global.amt_in_sales, daily_goal]
