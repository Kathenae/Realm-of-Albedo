extends Label

func _process(delta):
	text = "$" + StringUtils.put_space_after_3_letters(str(GameData.player_balance))
