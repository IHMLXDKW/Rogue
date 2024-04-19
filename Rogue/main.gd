extends Node

@export var enemy_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score("Enemies Spawned: " + str(score))
	$HUD.show_message("Get Ready")
	get_tree().call_group("enemy", "queue_free")

func _on_start_timer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score("Enemies Spawned: " + str(score))

func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position
	add_child(enemy)
