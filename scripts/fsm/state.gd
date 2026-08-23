# State.gd
extends Node
class_name State

signal state_transition(source_state: State, new_state_name: String)
var manager : FSM

func Enter(): pass
func Exit(): pass
func Update(_delta: float): pass
func PhysicsUpdate(_delta: float): pass
