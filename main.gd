extends Node

@export var mob_scene: PackedScene
@export var cutie_scene: PackedScene
var score
var cutie = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CutieTimer.stop()
	
	$HUD.show_game_over()	
	
func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("cuties", "queue_free")

func _on_mob_timer_timeout() -> void:
	create_mob()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$CutieTimer.start()

func _on_cutie_timer_timeout() -> void:
	if cutie == null:
		create_cutie()
	
func on_hit_cutie() -> void:
	score += 5
	remove_child(cutie)
	cutie = null
	$HUD.update_score(score)
	$CutieAcquiredSound.play()

func create_cutie() -> void:
	cutie = cutie_scene.instantiate()
	
	var cutie_spawn_location = $MobPath/MobSpawnLocation
	cutie_spawn_location.progress_ratio = randf()
	
	var direction = cutie_spawn_location.rotation + PI/2
	
	cutie.position = cutie_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	cutie.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	cutie.linear_velocity = velocity.rotated(direction)

	add_child(cutie)
	
func create_mob() -> void:
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI/2
	
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
