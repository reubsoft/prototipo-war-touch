extends Node2D

func _on_Clickable_tree_entered():
	get_tree().root.get_children()[0].get_node("Camera")
	print("Entrei")
