extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var colision = $ColisionPlayer


# Direção para onde o player está olhando
enum State{
	LEFT,
	RIGHT
}

enum Movement{
	WALKING,
	IDLE
}


@export var jump_force: float = 20.

var current_state = State.RIGHT
var current_movement = Movement.IDLE
var direction := Vector2.ZERO
var coyote_jump_time: float

@export_range(0.0, 99999.) var acceleration: float = 1.
@export_range(0.0, 99999.) var deacceleration: float = 10.
@export_range(0.0, 99999.) var max_speed: float = 20.
var target_speed: float = 0.0
var current_speed: float
var has_double_jumped: bool = false
var was_on_floor: bool

@export var gravity := Vector2.DOWN
var gravity_force: Vector2 # Vetor por que Talvez a gravidade fosse inclinada (mecânicas malucas :P)


## Muda a animação e acelera o jogador na direção que está sendo apertada
## Tambem liga a caixa de interação respectiva
func move(delta: float) -> void:
	var on_floor: bool = is_on_floor()
	#region _apply_gravity()
	if on_floor:
		# Aqui a gente quer manter as coisas estáveis
		# A magia dos games desliga a gravidade quando vc tá no chão kk
		# Se eu tivesse mais tempo tentaria usar umas slope aqui tmb
		gravity_force = Vector2.ZERO
	else:
		# Se estiver no ár, a gravidade só te faz acelerar.
		# Espero que não tenha pulado de muito alto :V
		gravity_force += gravity * delta
	
	# Eu poderia simplesmente aplicar direto na velocity
	# mas eu gosto assim, fica mais legível
	velocity = gravity_force
	#endregion
	
	if Input.is_action_pressed("left"):
		#region speed_up()
		target_speed = -max_speed
		#direction = Vector2.LEFT # ARCAICO
		#endregion
		
		current_state = State.LEFT
		current_movement = Movement.WALKING
	elif Input.is_action_pressed("right"):
		#region speed_up() # ARCAICO
		target_speed = max_speed
		#direction = Vector2.RIGHT
		#endregion
		
		current_state = State.RIGHT
		current_movement = Movement.WALKING
	else:
		#region speed_down()
		target_speed = 0.0
		#endregion
		current_movement = Movement.IDLE
	
	
	if coyote_jump_time <= 0:
		velocity.y += 1
		direction += Vector2.ZERO
	else:
		velocity.y = -1
		coyote_jump_time -= 1
		direction += Vector2.UP * jump_force
	
	if on_floor or coyote_jump_time > 0.0 and Input.is_action_just_pressed("jump"):
		pass # pausa pra salvar o progresso
	
	if Input.is_action_just_pressed("jump"):
		
		if coyote_jump_time == 0:
			coyote_jump_time = 20
	if current_movement == Movement.WALKING:
		#region _head_over()
		# Eu faria isso proceduralmente usando uma variável para controlar
		# o flip do sprite, para economizar no tamanho da textura (animações repetidas)
		# E então se quisesse ter animações independentes usaria o nó AnimationPlayer para isso
		# E potencialmente, se meu personagem tivesse muitas animações, usaria o AnimationTree
		#var is_heading_left: bool
		match(current_state):
			State.RIGHT:
				_animated_sprite.play("walk_right")
				#is_heading_left = false
			State.LEFT:
				_animated_sprite.play("walk_left")
				#is_heading_left = true
		#_animated_sprite.flip_h = is_heading_left
		#endregion
	else:
		# Se o jogador não está se movendo mostra sprite de parado na direção atual
		match(current_state):
			State.RIGHT:
				_animated_sprite.play("idle_right")
			State.LEFT:
				_animated_sprite.play("idle_left")
	# Acelera o jogador, se ele segurar shift acelera mais
	#velocity = velocity.normalized()
	velocity = velocity * 230
	
	if absf(current_speed) < absf(target_speed):
		current_speed = lerpf(current_speed, target_speed, acceleration * delta)
	else:
		current_speed = lerpf(current_speed, target_speed, deacceleration * delta)
	
	velocity.x = current_speed
	move_and_slide()
	was_on_floor = is_on_floor()



func _physics_process(delta):
	move(delta)
