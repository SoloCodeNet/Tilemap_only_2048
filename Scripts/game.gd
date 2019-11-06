extends Node2D
onready var board = $board
onready var data  = $data
onready var label = $game_over
onready var lbl_score = $canvas/lbl_score
onready var cam   = $cam
export(int) var sz = 4
onready var piece = preload("res://Scenes/piece.tscn")
var score = 0
var next : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_board()
	add_new()
	next = true
	score = 0

func make_board():
	for x in sz:
		for y in sz:
			board.set_cell(x, y, 0)
			data.set_cell(x, y, 0)
			
	var posi_cam: float = board.cell_size.x * board.scale.x * sz / 2
	cam.position = Vector2(posi_cam, posi_cam)
	label.rect_position.x = posi_cam - (label.rect_size.x / 2)
	cam.zoom.x = 1.0 + ((float(sz) - 3.0)/ 10)
	cam.zoom.y = 1.0 + ((float(sz) - 3.0)/ 10)
	
func add_new():
	randomize()
	var rest = data.get_used_cells_by_id(0).size()
	if rest > 0:
		var num = randi()% 2 +1
		var rnd = data.get_used_cells_by_id(0)[randi()% rest]
		var t = piece.instance()
		t.position = (board.map_to_world(rnd) * board.scale.x) + (board.cell_size/2 * board.scale.x)
		
		add_child(t)
		t.add(num)
		yield(t, "tree_exited")
		data.set_cellv(rnd, num)
	else:
		next = false
		label.visible = true
	
func _process(delta: float) -> void:
	lbl_score.text = "SCORE: " + str(score)
	label.visible = !next
	var dir = input_loop()
	if dir!= Vector2.ZERO:
		merge(dir)
		move(dir)
		add_new()
	
		
func input_loop()-> Vector2:
#	if !next and  Input.is_action_just_pressed("ui_cancel"): get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel"): get_tree().reload_current_scene()
	var dir:=Vector2.ZERO
	
	if   Input.is_action_just_pressed("ui_right") and next :dir = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left")  and next :dir = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_down")  and next :dir = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up")    and next :dir = Vector2.UP
	return dir
	
func merge(vec:Vector2):
	if vec == Vector2.LEFT:
		for x in range(0, sz, 1):
			for y in range(0, sz, 1):
				var index = data.get_cell(x, y)
				for z in range(x + 1, sz):
					var a = data.get_cell(z, y)
					if a != 0:
						if index == a:
							data.set_cell(x,y, a+1)
							data.set_cell(z,y, 0)
							score+= pow(2, a+1)
						break
							
	if vec == Vector2.RIGHT:
		for x in range(sz-1, 0, -1):
			for y in range(0, sz, 1):
				var index = data.get_cell(x, y)
				for z in range(x-1, -1, -1 ):
					var a = data.get_cell(z, y)
					if a != 0 :
						if a == index:
							data.set_cell(x,y, a+1)
							data.set_cell(z,y, 0)
							score+= pow(2, a+1)
						break
	
	if vec == Vector2.UP:
		for y in range(0, sz, 1):
			for x in range(0, sz):
				var index = data.get_cell(x, y)
				for z in range(y+1, sz):
					var a = data.get_cell(x, z)
					if a != 0:
						if a == index:
							data.set_cell(x, y, a+1)
							data.set_cell(x, z, 0)
							score+= pow(2, a+1)
						break

	if vec == Vector2.DOWN:
		for y in range(sz, -1, -1):
			for x in range(0, sz):
				# ============================= MERGE
				var index = data.get_cell(x, y)
				if index != -1:
					for z in range(y-1, -1, -1):
						var a = data.get_cell(x, z)
						if a != 0:
							if a == index:
								data.set_cell(x, y, a+1)
								data.set_cell(x, z, 0)
								score+= pow(2, a+1)
							break
							
func move(vec:Vector2):
	if vec == Vector2.LEFT:
		for x in range(0, sz, 1):
			for y in range(0, sz, 1):
				var index = data.get_cell(x, y)
				if index == 0:
					for z in range(x + 1, sz):
						var a = data.get_cell(z, y)
						if a != 0:
							data.set_cell(x,y, a)
							data.set_cell(z,y, 0)
							break
							
	if vec == Vector2.RIGHT:
		for x in range(sz-1, 0, -1):
			for y in range(0, sz, 1):
				var index = data.get_cell(x, y)
				if index == 0:
					for z in range(x-1, -1, -1 ):
						var a = data.get_cell(z, y)
						if a != 0 :
							data.set_cell(x,y, a)
							data.set_cell(z,y, 0)
							break
							
	if vec == Vector2.UP:
		for y in range(0, sz, 1):
			for x in range(0, sz):
				var index = data.get_cell(x, y)
				if index == 0:
					for z in range(y+1, sz):
						var a = data.get_cell(x, z)
						if a != 0:
							data.set_cell(x, y, a)
							data.set_cell(x, z, 0)
							break
							
	if vec == Vector2.DOWN:
		for y in range(sz, -1, -1):
			for x in range(0, sz):
				var index = data.get_cell(x, y)
				if index == 0:
					for z in range(y-1, -1, -1):
						var a = data.get_cell(x, z)
						if a != 0:
							data.set_cell(x, y, a)
							data.set_cell(x, z, 0)
							break
