extends Node
# Klasa odpowiedzialna za zarządzanie przeciwnikiem.
class_name Enemy

@export var attacks : Array[AttackDescription]
@export var sprite: Sprite2D
@export var lowhp_texture: Texture2D
var lastAttack : AttackDescription
var stats: Stats
var effects : EffectArray

signal enemy_selected(enemy)

# Przechowuje oryginalną teksturę do przywrócenia
var _normal_texture: Texture2D

func _ready() -> void:
	# Inicjalizacja komponentów Stats i EffectArray
	for child in get_children():
		if child is Stats:
			stats = child as Stats
		elif child is EffectArray:
			effects = child as EffectArray

	# Połączenie sygnału input
	var area = $Area2D
	area.input_pickable = true
	area.input_event.connect(_on_area_2d_input_event)

	# Zapisz oryginalną teksturę
	_normal_texture = sprite.texture

	# Jeśli przeciwnik ma współdzielony materiał, sklonuj go
	if sprite.material:
		sprite.material = sprite.material.duplicate()

	# Wyczyszczenie wiadomości
	$Stats/AttackMessage.text = ""

# Funkcja wywoływana przy zmianie życia w Stats
func OnHealthChanged(current_health: int, max_health: int) -> void:
	if current_health <= max_health / 2:
		# Poniżej lub równo 50% - zastąp teksturę
		sprite.texture = lowhp_texture
	else:
		# Powyżej 50% - przywróć oryginalną teksturę
		sprite.texture = _normal_texture

# Funkcja dająca możliwość przeciwnikowi wykonania odpowiednich akcji.
func DoActions():
	if stats.should_run_away:
		stats.SetHealth(0)
		GameManager.EndEnemyTurn(self)
		return

	if stats.should_skip_turn:
		GameManager.EndEnemyTurn(self)
		return

	var attackSet: Array[AttackDescription] = attacks
	if lastAttack and lastAttack.nextAttackSet:
		attackSet = lastAttack.nextAttackSet

	for i in attackSet:
		if i.isAggressive:
			i.weight *= stats.aggresive_attack_chance_mult
		if i.isUseful:
			i.weight *= stats.useful_attack_chance_mult
		if i.isSpecial:
			i.weight *= stats.special_attack_chance_mult

	var attack = AttackDescription.PickRandomAttack(attackSet)

	for i in attackSet:
		if i.isAggressive:
			i.weight /= stats.aggresive_attack_chance_mult
		if i.isUseful:
			i.weight /= stats.useful_attack_chance_mult
		if i.isSpecial:
			i.weight /= stats.special_attack_chance_mult
	lastAttack = attack

	# Wyświetlanie wiadomości o ataku
	$Stats/AttackMessage.text = str(attack.message)
	GameManager.player.stats.DealDamage(attack.damage)
	GameManager.EndEnemyTurn(self)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		set_as_current_enemy()

func set_as_current_enemy():
	# Resetuj shader dla wszystkich przeciwników
	for enemy in GameManager.enemies:
		if enemy and enemy.has_method("reset_shader"):
			enemy.reset_shader()

	# Zaznacz aktualnego przeciwnika
	enemy_selected.emit(self)

	# Zmień grubość linii tylko dla wybranego przeciwnika
	if sprite.material and sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("thickness", 1.0)

func reset_shader():
	if sprite.material and sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("thickness", 0.0)
