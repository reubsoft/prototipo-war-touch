extends Camera2D


var objectsSelected = []
var myUnits = []
var selection
var touch = false
var pos = Vector2()
var newPos = Vector2()
var sizeCircle = 50


func _ready():
	myUnits = get_tree().get_nodes_in_group("MY")
	objectsSelected = get_tree().get_nodes_in_group("ENEMY")
	objectsSelected += myUnits
	
	# futuramente pode sair que está usando é as bases assim que entram na tela
func _objectSelectedAdd(body):
	objectsSelected.append(body)
	
func _objectSelectedRemove(body):
	objectsSelected.remove(objectsSelected.find(body))
	
func _myUnitsAdd(body):
	myUnits.append(body)
	
func _myUnitsRemove(body):
	myUnits.remove(myUnits.find(body))

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		pos = getPositionTouch(event)
		for i in myUnits:
			if Rect2(pos-Vector2(100,100)/2, Vector2(100,100)).has_point(i.global_position):
				selection = i
				newPos = pos
				update()
				touch = true
	if event is InputEventScreenDrag and touch:
		newPos = getPositionTouch(event)
		update()
	
	if event is InputEventScreenTouch and !event.pressed:
		pos = getPositionTouch(event)
		if touch:
			for i in objectsSelected:
				if i != selection:
					if Rect2(pos-Vector2(100,100)/2, Vector2(100,100)).has_point(i.global_position):
						pos = i.global_position
						selection.attack(i)
		touch = false
		update()
		
func getPositionTouch(event):
	return get_viewport().canvas_transform.affine_inverse().xform(event.position)

func _draw():
	if touch:
		var angle = newPos.angle_to_point(pos)
		var points = PoolVector2Array([Vector2(20,0).rotated(angle)+newPos,Vector2(0,20).rotated(angle)+newPos,Vector2(0,-20).rotated(angle)+newPos])
		draw_polygon(points,PoolColorArray([Color(0.92, 0.228,0, 0.5)]))
		draw_line(pos, newPos, Color(0.92, 0.228,0, 0.5), 20)
		draw_circle(pos, sizeCircle, Color(0.92, 0.228,0, 0.5))
		draw_rect(Rect2(newPos-Vector2(100,100)/2, Vector2(100,100)), Color(0.92, 0.52,0, 0.5))
		
