extends Spatial

signal new_screenshot(texture)

func _unhandled_key_input(event):
	
	if event.pressed and event.scancode == KEY_F12:
		
		# Get the texture from the viewport
		var viewport_texture = get_viewport().get_texture()
		
		# Get an image from the viewport texture, do the flip as recommended
		var img = viewport_texture.get_data()
		img.flip_y()
		
		# Tell the UI that a screenshot has been taken
		var image_texture = ImageTexture.new()
		image_texture.create_from_image(img,viewport_texture.flags)
		emit_signal("new_screenshot",image_texture)
		
		# Save the image to a file
		
		var current_dt = OS.get_datetime()
		var year = str(current_dt.year)
		var month = StringUtils.get_month_name(current_dt.month) # TODO: Use OS locale for the name of the month
		var day = str(current_dt.day)
		var time = str(current_dt.hour) + "-" + str(current_dt.minute) + "-" + str(current_dt.second)
		var date = day + " " + month + " " + year + " " + time
		
		var path = ProjectSettings.globalize_path("user://Screenshot from " + date + ".png")
		var _err = img.save_png(path)
