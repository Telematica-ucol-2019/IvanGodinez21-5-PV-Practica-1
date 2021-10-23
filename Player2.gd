extends Area2D

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size
var life = Resources.life  # Singleton variable

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		if position.x <= 1024:
			velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		if position.x >= 0:
			velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player2_body_entered(body):
	if ((body.get_name() == "Enemy1") || (body.get_name() == "Enemy2") || (body.get_name() == "Enemy3") || (body.get_name() == "Enemy4") || (body.get_name() == "Enemy5") || (body.get_name() == "Enemy6") || (body.get_name() == "Enemy7") || (body.get_name() == "Enemy8") || (body.get_name() == "Boss")):
		hide()  # Player disappears after being hit.
		emit_signal("hit")
		$PainSound.volume_db = 10
		if ($PainSound.playing == false):
			$PainSound.play()
		life -= 1
		get_node("../LifeCounterPlayer2").text = str("2P Lives: ",life) 
		if (life > 0):
			position.x = 512
			position.y = 580
			start(position)
		else:
				$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
	
