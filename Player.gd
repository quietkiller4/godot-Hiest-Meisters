extends KinematicBody2D

var motion = Vector2()
const SPEED = 20
const MAXSPEED = 200
const FRICTION = 0.07
const PLAYER_SPRITE = "res://assets/Heist_Meisters_Assets/GFX/PNG/Hitman 1/hitman1_stand.png"
const BOX_SPRITE = "res://assets/Heist_Meisters_Assets/GFX/PNG/Tiles/tile_130.png"
const PLAYER_OCCLUDER = "res://Characters/HumanOccluder.tres"
const BOX_OCCLUDER = "res://Characters/BoxOccluder.tres"
const PLAYER_LIGHT = "res://assets/Heist_Meisters_Assets/GFX/PNG/Hitman 1/hitman1_stand.png"
const BOX_LIGHT = "res://assets/Heist_Meisters_Assets/GFX/PNG/Tiles/tile_130.png"

var velocity_multiplier = 1

var disguised = false
export var disguise_slowdown = 0.75
export var disguised_duration = 5
export var number_of_disguises = 3

func _ready():
	$Timer.wait_time = disguised_duration
	get_tree().call_group("DisguiseDisplay", "update_disguises", number_of_disguises)

func _physics_process(delta):
	update_movement()
	motion = move_and_slide(motion * velocity_multiplier)
	if disguised:
		$DisguiseLabel.text = str($Timer.time_left).pad_decimals(2)
		$DisguiseLabel.rect_rotation = -rotation_degrees
	
func update_movement():
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
		motion.y = clamp(motion.y + SPEED, 0, MAXSPEED)
	elif Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		motion.y = clamp(motion.y - SPEED, -MAXSPEED, 0)
	else:
		motion.y = lerp(motion.y, 0, FRICTION)
		
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		motion.x = clamp(motion.x - SPEED, -MAXSPEED, 0)
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		motion.x = clamp(motion.x + SPEED, 0, MAXSPEED)
	else:
		motion.x = lerp(motion.x, 0, FRICTION)

func _input(event):
	if Input.is_action_just_pressed("toggle_vision_mode"):
		get_tree().call_group("Interface", "cycle_vision_mode")
		
	if Input.is_action_just_pressed("toggle_disguise"):
		toggle_disguise()
		
func toggle_disguise():
	if disguised:
		reveal()
	elif number_of_disguises > 0:
		disguised()


func reveal():
	$PlayerSprite.texture = load(PLAYER_SPRITE)
	$Light2D.texture = load(PLAYER_LIGHT)
	$LightOccluder2D.occluder = load(PLAYER_OCCLUDER)
	$DisguiseLabel.hide()
	velocity_multiplier = 1
	
	disguised = false
	collision_layer = 1
	
func disguised():
	$PlayerSprite.texture = load(BOX_SPRITE)
	$Light2D.texture = load(BOX_LIGHT)
	$LightOccluder2D.occluder = load(BOX_OCCLUDER)
	$DisguiseLabel.show()
	velocity_multiplier = disguise_slowdown
	number_of_disguises -= 1
	get_tree().call_group("DisguiseDisplay", "update_disguises", number_of_disguises)
	disguised = true
	collision_layer = 16
	$Timer.start()

func _on_Timer_timeout():
	reveal()
	
func collect_briefcase():
	var loot = Node.new()
	loot.set_name("Briefcase")
	add_child(loot)
	get_tree().call_group("Loot", "collect_loot")
