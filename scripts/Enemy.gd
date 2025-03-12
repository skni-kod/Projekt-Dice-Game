extends Node
# Klasa odpowiedzialna za zarządzanie przeciwnikiem.
class_name Enemy
	
var stats:Stats
@export var attacks : Array[AttackDescription]
var lastAttack : AttackDescription
var temporaryEffects : Array[TemporaryEffect]

signal enemy_selected(enemy)

func _ready() -> void:
	stats = get_child(0) as Stats
	var area = $Area2D
	area.input_pickable = true
	area.input_event.connect(_on_area_2d_input_event)

	# Jeśli przeciwnik ma współdzielony materiał, sklonuj go
	if self.material:
		self.material = self.material.duplicate()
		
# Funkcja dająca możliwość przeciwnikowi wykonania odpowiednich akcji.
func DoActions():
	var attack:AttackDescription
	if lastAttack and lastAttack.nextAttackSet:
		attack = AttackDescription.PickRandomAttack(lastAttack.nextAttackSet)
	else:
		attack = AttackDescription.PickRandomAttack(attacks)
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
	if self.material and self.material is ShaderMaterial:
		self.material.set_shader_parameter("thickness", 1.0)  # Pogrubienie
		
func reset_shader():
	if self.material and self.material is ShaderMaterial:
		self.material.set_shader_parameter("thickness", 0.0)  # Reset do domyślnej wartości
