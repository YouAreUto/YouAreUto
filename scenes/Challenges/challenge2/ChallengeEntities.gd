extends Node2D

# the 3 horizontally aligned guards in front of the castle
onready var servant = $Servant
onready var servant2 = $Servant2
onready var servant3 = $Servant3


func setServantPaths():
	var servantBounds = Vector2(100, 100) # TODO: this is an approximation!
	var vw_size = Global.vw.size
	# left servant path
	var servantLeftPath: Path2D = $ServantLeftPath
	servantLeftPath.position = Vector2()
	servantLeftPath.curve = Curve2D.new()
	servantLeftPath.curve.add_point(Vector2(-servantBounds.x, vw_size.y / 2))
	servantLeftPath.curve.add_point(Vector2(servant.position.x, vw_size.y / 2))
	servantLeftPath.curve.add_point(Vector2(servant.position.x, servant.position.y))

	# right servant path
	var servantRightPath: Path2D = $ServantRightPath
	servantRightPath.position = Vector2()
	servantRightPath.curve = Curve2D.new()
	servantRightPath.curve.add_point(Vector2(vw_size.x + servantBounds.x, vw_size.y / 2))
	servantRightPath.curve.add_point(Vector2(servant3.position.x, vw_size.y / 2))
	servantRightPath.curve.add_point(Vector2(servant3.position.x, servant3.position.y))

	# central servant path
	var servantCenterPath: Path2D = $ServantCenterPath
	servantCenterPath.position = Vector2()
	servantCenterPath.curve = Curve2D.new()
	servantCenterPath.curve.add_point(Vector2(vw_size.x / 2, vw_size.y + servantBounds.y))
	servantCenterPath.curve.add_point(servant2.position)


func _on_Definitely_UtoBecameACastleServant():
	for servant in get_tree().get_nodes_in_group("guards"):
		servant.get_node("UtoGameoverArea").monitoring = false
