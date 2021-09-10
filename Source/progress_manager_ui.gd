extends Node

func _on_progress_manager_miles_traveled_changed(new_milage):
	var miles_text = str(round(new_milage))
	miles_text = StringUtils.put_space_after_3_letters(miles_text) + " m"
	$score_label.text =  miles_text

func _on_progress_manager_coins_changed(new_count):
	$coins_label.text = StringUtils.put_space_after_3_letters(str(round(new_count))) + " $"

func _on_progress_manager_new_achievement(achievement):
	$achievement_label.text = achievement.name + "\n\n"
	$achievement_label.text += achievement.complete_message
	$Notifications.play("achievement_label_anim")
	$reached_sound.play()

var goals_being_displayed = []

func _on_progress_manager_achievement_progress(achievement, progress_percent):
	
	if goals_being_displayed.has(achievement):
		progress_percent = str(round(progress_percent * 100))
		var amount_left = StringUtils.put_space_after_3_letters(str(achievement.current))
		var target_amount = StringUtils.put_space_after_3_letters(str(achievement.target))
		
		var index = goals_being_displayed.find(achievement)
		$goals.get_child(index).text = achievement.short_description + " (" +  progress_percent + "%)"
		# $goals.get_child(index).text += "\n" + amount_left + "/" + target_amount + " m"


func _on_progress_manager_level_started(level_goals : Array):
	
	for i in range(level_goals.size()):
		var achievement = level_goals[i]
		var progress_percent = inverse_lerp(0,achievement.target, achievement.current)
		progress_percent = str(round(progress_percent * 100))
		var amount_left = StringUtils.put_space_after_3_letters(str(achievement.current))
		var target_amount = StringUtils.put_space_after_3_letters(str(achievement.target))
		$goals.get_child(i).text = achievement.short_description + " (" +  progress_percent + "%)"
		# $goals.get_child(i).text += "\n" + amount_left + "/" + target_amount + " m"
	
	goals_being_displayed = level_goals
