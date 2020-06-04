extends Button
tool

export(Texture) var decorationTexture
export(bool) var customMargin
export(int) var customLeftMargin


func _ready() -> void:
	$DecorationLeft.texture = decorationTexture
	if customMargin:
		$DecorationLeft.margin_left = customLeftMargin
