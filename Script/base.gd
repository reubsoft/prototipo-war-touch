extends Sprite

const MAX_UNITS = 20

var units = 1
export var ative = false
export(String) var team = "ENEMY"
var bullet_pre = preload("res://Scene/bullet.tscn")

func _ready():
	add_to_group(team)
	$Label.text = str(units)
	if !ative:
		$Timer.stop()
	
func attack(objet):
	$Timer.stop()
	while units > 0:
		var bullet = bullet_pre.instance()
		owner.add_child(bullet)
		bullet._team(team)
		bullet._target(objet.global_position)
		bullet.applyForce(1)
		units -= 1
		$Label.text = str(units)
		var angle = objet.global_position.angle_to_point(global_position)
		bullet.global_position = Vector2(50,0).rotated(angle) + self.global_position
		yield(get_tree().create_timer(.3), "timeout")
	$Timer.start()
	
func hitEnemy(value, group):
	$Timer.stop()
	hit(value, group)
	
func hit(value, group):
	units += value
	if units < 0:
		units = 0
		remove_from_group(team)
		add_to_group(group)
		team = group
		_paint()
	$Label.text = str(units)
	$Timer.start()

func _paint():
	if team == "MY":
		modulate = Color(1,1,1)
		get_tree().root.get_children()[0].get_node("Player")._myUnitsAdd(self)
	else:
		modulate = Color(0,0.52,1)
		get_tree().root.get_children()[0].get_node("Player")._myUnitsRemove(self)

func _on_Timer_timeout():
	if units > MAX_UNITS-1:
		$Timer.stop()
	else:
		units += 1
	$Label.text = str(units)
	
func _on_Sprite_tree_entered():
	get_tree().root.get_children()[0].get_node("Player")._objectSelectedAdd(self)
	
func _on_Sprite_tree_exiting():
	get_tree().root.get_children()[0].get_node("Player")._objectSelectedRemove(self)
