extends ItemList

func update_disguises(number):
	clear()
	for disguises in range(number):
		add_icon_item(load("res://assets/Heist_Meisters_Assets/GFX/PNG/Tiles/tile_130.png"), false)
