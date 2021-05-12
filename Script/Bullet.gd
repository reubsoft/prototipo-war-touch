extends Area2D

var target
var nameFather = ""
var force = 1
var offset
var team
func _ready():
	pass # Replace with function body.

func _process(delta):
	offset = target - global_position
	offset = offset.normalized()
	translate(offset * 200 * delta)

func _team(value):
	team = value

func _target(value):
	target = value
	
func applyForce(value):
	force = value
	$Label.text = str(force)
	
func _on_Bullet_area_entered(area):
	if area.get_parent().is_in_group("ENEMY"):
		area.get_parent().hitEnemy(-force, team)
		queue_free()
		
	elif area.get_parent().is_in_group("MY"):
		area.get_parent().hit(force, team)
		queue_free()
