extends Resource
# Zasób opisujący atak, np. przeciwnika.
class_name AttackDescription

@export var damage: int # Ilość zadawanych obrażeń.
@export var message: String # Wiadomość jaka ma być wyświetlana podczas ataku.
@export var effect: TemporaryEffect # Opcjonalny efekt jaki ma być nadany na przeciwnika.
@export var nextAttack: AttackDescription # Opcjonalny następny atak.

func _init(damage_ = 0, message_ = "", effect_: TemporaryEffect = null, nextAttack_: AttackDescription = null):
	damage = damage_
	message = message_
	effect = effect_
	nextAttack = nextAttack_
