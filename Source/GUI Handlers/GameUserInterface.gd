# Receives signals to update the UI


extends CanvasLayer

func _on_screenshot_manager_screen_shot_taken(texture):
	
	pass

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_H:
		$main.visible = not $main.visible

func _on_player_vehicle_damaged(percent_left):
	var tween = $Tween
	var start = $main/player_status_ui/health_front.rect_size.x
	var end = lerp(0,$main/player_status_ui/health_bg.rect_size.x,percent_left)
	tween.interpolate_property($main/player_status_ui/health_front,"rect_size:x",start,end,1.0,Tween.TRANS_SINE)
	tween.start()

func _on_player_vehicle_death():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$lose_screen.show()
	GameData.save_data()

func _on_scenery_manager_scenery_changed(new_scenery):
	$main/scenery_label.text = new_scenery.name
	$AnimationPlayer.play("scenery_label_anim")

func _on_exit_pressed():
	transition_to_scene(GameData.menu_scene)

func _on_restart_pressed():
	transition_to_scene(GameData.play_scene)

func transition_to_scene(scene : PackedScene):
	$Transitions.play("bg_fade_out")
	scene_to_load = scene

var scene_to_load = null
func fade_out_end():
	get_tree().change_scene_to(scene_to_load)
