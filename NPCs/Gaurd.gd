extends KinematicBody2D

const SPEED = 20
const MAXSPEED = 200
const FRICTION = 0.07
const FOV_TOLERANCE = 20
const RED = Color(1, 0.25, 0.25)
const WHITE = Color(1, 1, 1)
const MAX_DETECTION_RANGE = 640

var Player

#onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
#onready var destination =  navigation.get_node("Destinations")

#var motion
#var possible_destination
#var path

#export var minimun_arrival_distance = 5
#export var walk_speed = 0.5

func _ready():
	Player = get_node("/root").find_node("Player", true, false)
	#randomize()
	#possible_destination = destination.get_children()
	#make_path()
	
#func _physics_process(delta):
	#navigate()
	
#func navigate():	
	#var distance_to_destination = position.distance_to(path[0])
	#if distance_to_destination > minimun_arrival_distance:
		#move()
	#else:
		#update_path()
			
#func move():
#	look_at(path[0])
#	motion = path[0] - position.normalized() * (MAXSPEED * walk_speed)
#	move_and_slide(motion)
#
#func update_path():
#	if path.size() == 1 and $Timer.is_stopped():
#		$Timer.start()
#	else:
#		path.remove(0)
#
#func make_path():
#	var new_destination = possible_destination[randi() % possible_destination.size() - 1]
#	path = navigation.get_simple_path(position, new_destination.position)
#	print(path)

func _process(delta):
	if Player_in_FOV() and Player_in_LOS():
		$Torch.color = RED
	else:
		$Torch.color = WHITE
		
func Player_in_FOV():
	var npc_facing_direction = Vector2(1, 0).rotated(global_rotation)
	var direction_to_Player = (Player.position - global_position).normalized()
	
	if abs(direction_to_Player.angle_to(npc_facing_direction)) < deg2rad(FOV_TOLERANCE):
		return true
	else:
		return false

func Player_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position, Player.global_position, [self], collision_mask)

	if not LOS_obstacle:
		return false
	
	var distance_to_player = Player.global_position.distance_to(global_position)
	var Player_in_range = distance_to_player < MAX_DETECTION_RANGE
	
	if LOS_obstacle.collider == Player and Player_in_range:
		return true
	else:
		return false


#func _on_Timer_timeout():
#	make_path()
