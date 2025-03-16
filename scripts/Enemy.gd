extends Node
# Klasa odpowiedzialna za zarządzanie przeciwnikiem.
class_name Enemy
	
@export var attacks : Array[AttackDescription]
@export var sprite: Sprite2D
var lastAttack : AttackDescription
var stats:Stats
var effects : EffectArray

signal enemy_selected(enemy)

func _ready() -> void:
	for child in get_children():
		if child is Stats:
			stats = child as Stats
		elif child is EffectArray:
			effects = child as EffectArray
	
	var area = $Area2D
	area.input_pickable = true
	area.input_event.connect(_on_area_2d_input_event)

	# Jeśli przeciwnik ma współdzielony materiał, sklonuj go
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	# Wyczyszczenie wiadomości	
	$Stats/AttackMessage.text = ""	
# Funkcja dająca możliwość przeciwnikowi wykonania odpowiednich akcji.
func DoActions():
	if stats.should_run_away:
		stats.SetHealth(0)
		GameManager.EndEnemyTurn(self)
		return
	
	if stats.should_skip_turn:
		GameManager.EndEnemyTurn(self)
		return
	
	var attack:AttackDescription
	var attackSet:Array[AttackDescription] = attacks
	if lastAttack and lastAttack.nextAttackSet: attackSet = lastAttack.nextAttackSet
	
	for i in attackSet:
		if i.isAggressive: i.weight *= stats.aggresive_attack_chance_mult
		if i.isUseful: i.weight *= stats.useful_attack_chance_mult
		if i.isSpecial: i.weight *= stats.special_attack_chance_mult
		
	attack = AttackDescription.PickRandomAttack(attackSet)
	
	for i in attackSet:
		if i.isAggressive: i.weight /= stats.aggresive_attack_chance_mult
		if i.isUseful: i.weight /= stats.useful_attack_chance_mult
		if i.isSpecial: i.weight /= stats.special_attack_chance_mult
	lastAttack = attack
	
	# TO DO: Dodać wyświetlanie wiadomości
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
		sprite.material.set_shader_parameter("thickness", 1.0)  # Pogrubienie
		
func reset_shader():
	if sprite.material and sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("thickness", 0.0)  # Reset do domyślnej wartości
