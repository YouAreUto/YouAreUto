extends Path2D

var monitorDirectionChange = false # this is activated only when in a specific area near the stop point
var justRestarted = false
onready var ch3 = get_node("/root/Challenge3")

var distance = null
var previousDistance = null


func _ready() -> void:
	get_node("/root/Challenge3/Servant1StopPoint").monitoring = ch3.isPuzzleSolved()


func _process(delta: float) -> void:
	if monitorDirectionChange:
		if previousDistance == null: # it's the first iteration, take only the current distance
			distance = $PathFollow2D.position.distance_to(curve.get_point_position(5))
			previousDistance = distance
			return
		previousDistance = distance
		distance = $PathFollow2D.position.distance_to(curve.get_point_position(5))
		if distance > previousDistance and $AnimationPlayer.playback_active and !justRestarted:
			pauseMovement()


func pauseMovement():
	$AnimationPlayer.playback_active = false
	$Timer.start()


func _on_Timer_timeout() -> void:
	justRestarted = true
	$AnimationPlayer.playback_active = true
	previousDistance = null
	distance = null


func resetFlag():
	justRestarted = false


func _on_Servant1StopPoint_area_entered(area: Area2D) -> void:
	if area.name == 'BottomPointCheckerArea':
		monitorDirectionChange = true


func _on_Servant1StopPoint_area_exited(area: Area2D) -> void:
	if area.name == 'BottomPointCheckerArea':
		monitorDirectionChange = false
