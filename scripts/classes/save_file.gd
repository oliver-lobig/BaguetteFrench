extends Resource
class_name SaveFile

@export var baguette_style_data: BaguetteStyleData = BaguetteStyleData.new()
@export var baguette_shop_assortment: BaguetteShopAssortment = BaguetteShopAssortment.new()

@export var words: Array = []
@export var marked_words: Array = []
@export var field_progress: Dictionary = {}
@export var current_scroll: int = 0
@export var max_unit: int = 1

@export var learn_points: int = 0

@export var settings_data: SettingsData = SettingsData.new()

@export var done_field_ids: Array = []
@export var chapter_content: Dictionary = {}

@export var all_learn_words: Array = []
@export var all_learn_verbs: Array = []

@export var verbs: Dictionary = {}

@export var last_save_ids: Dictionary = {
	"words":"-1",
	"path":"-1",
	"shop_assortment":"-1"
}

@export var own_categorys: Dictionary = {}

@export var challenge_progress: Dictionary = {
	
}
