extends KinematicBody

const ROT = 0.01
export var SPEED = 300

export var Gr = -1
export var JUMP_SPEED = 40
const STOP = -0.001

var vel = Vector3()

var rot_x = 0
var rot_y = 0

var LEFT = false
var RIGHT = false
var JUMP = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var dir = Vector3()
	if is_on_wall():
		get_node("..").game_over()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_left"):
		dir.z = 1
	if Input.is_action_pressed("ui_right"):
		dir.z = -1
	if not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
			dir.x = 0; dir.z = 0
	
	dir *= SPEED * delta
	vel.x = -SPEED * delta
	vel.z = dir.z
	vel.x += STOP * delta
	vel.y += Gr * delta
	vel.z += STOP * delta
	
	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			vel.y = JUMP_SPEED
			transform = transform.orthonormalized()
	vel = move_and_slide(vel, Vector3(0,1,0))


func _on_Area_body_entered(body):
	get_node("../Win").show()
	get_node("../GameOver").pause_mode = Node.PAUSE_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _on_GameOverFloor_body_entered(body):
	get_node("..").game_over()