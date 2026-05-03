@tool
extends Node
var searching_id: int = 0
var searching_uid: int = 0
var searching_unit: int = 0

var filter_type: int = 0
var filter_invert: bool = false
var filter_category: int = 0

func word_has_id(word: Word):
	if word.id == searching_id:
		return true
	else:
		return false

func word_has_uid(word: Word):
	if word.uid == searching_uid:
		return true
	else:
		return false

func get_words_until_unit(unit: int):
	searching_unit = unit
	var new_array = Vars.words.filter(word_until_unit)
	return new_array
	
func word_in_unit(word: Word) -> bool:
	if word.unit_id == searching_unit:
		return true
	else:
		return false

func word_until_unit(word: Word) -> bool:
	if word.unit_id <= searching_unit:
		return true
	else:
		return false

func get_verbs_in_unit(unit: int) -> Array:
	searching_unit = unit
	var new_array = Vars.verbs.values().filter(verb_in_unit)
	return new_array

func verb_in_unit(verb: Verb) -> bool:
	if verb.category == searching_unit:
		return true
	else:
		return false


func get_words_string(input: Array) -> String:
	var output: String = ""
	for word_id in range(len(input)):
		var value = input[word_id]
		output += value
		if word_id != len(input) - 1:
			output += "; " 
	return output

func get_word_from_id(id: int) -> Word:
	searching_id = id
	var word_id = Vars.words.find_custom(word_has_id)
	if word_id == -1:
		return null
	return Vars.words[word_id]

func get_word_from_uid(uid: int) -> Word:
	searching_uid = uid
	var word_id = Vars.words.find_custom(word_has_uid)
	if word_id == -1:
		return null
	return Vars.words[word_id]

func check_correct(user_input: String, correct_words: Array, language: String, sign_replace: bool = true):
	var is_correct: bool = false
	for word in correct_words:
		var clean_word = word.strip_edges()
		var edited_user_word = ""
		var edited_real_word = ""
		if language == "french":
			if clean_word.begins_with("une ") or clean_word.begins_with("la "):
				edited_user_word = user_input.strip_edges().replace("une ","").replace("la ","")
				edited_real_word = clean_word.replace("une ","").replace("la ","")
			elif clean_word.begins_with("un ") or clean_word.begins_with("le "):
				edited_user_word = user_input.strip_edges().replace("un ","").replace("le ","")
				edited_real_word = clean_word.replace("un ","").replace("le ","")
		elif language == "german":
			if clean_word.begins_with("der "):
				edited_user_word = user_input.strip_edges().replace("der ","").replace("ein ","")
				edited_real_word = clean_word.replace("der ","").replace("ein ","")
			elif clean_word.begins_with("die ") or clean_word.begins_with("eine "):
				edited_user_word = user_input.strip_edges().replace("die ","").replace("eine ","")
				edited_real_word = clean_word.replace("die ","").replace("eine ","")
			elif clean_word.begins_with("das "):
				edited_user_word = user_input.strip_edges().replace("das ","").replace("ein ","")
				edited_real_word = clean_word.replace("das ","").replace("ein ","")
			elif clean_word.begins_with("ein "):
				edited_user_word = user_input.strip_edges().replace("das ","").replace("ein ","").replace("der ","")
				edited_real_word = clean_word.replace("das ","").replace("ein ","").replace("der ","")
		if edited_real_word == "":
			edited_real_word = clean_word
		if edited_user_word == "":
			edited_user_word = user_input.strip_edges()
		if sign_replace == true:
			edited_real_word = edited_real_word.replace("!","").replace("?","").replace(".","").replace("œ","oe")
			edited_user_word = edited_user_word.replace("!","").replace("?","").replace(".","").replace("œ","oe")
		if edited_real_word.to_lower() == edited_user_word.to_lower():
			is_correct = true
	return is_correct

func get_verb_full_text(word: Word, verb: Verb, language: String, suffix_id: int = 0) -> String:
	if !verb:
		return WordHandler.get_words_string(word.german) if language == "german" else WordHandler.get_words_string(word.french)
	var version = ""
	for verb_version in verb.versions.keys():
		if verb.versions[verb_version] == word:
			version = verb_version
	if version == "":
		return WordHandler.get_words_string(word.german) if language == "german" else WordHandler.get_words_string(word.french)
	match version:
		"s1":
			if language == "german":
				return add_suffix("Ich ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Je ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"s2":
			if language == "german":
				return add_suffix("Du ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Tu ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"s3":
			if language == "german":
				return add_suffix("Laurene ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Laurene ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"p1":
			if language == "german":
				return add_suffix("Wir ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Nous ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"p2":
			if language == "german":
				return add_suffix("Ihr ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Vous ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"p3":
			if language == "german":
				return add_suffix("Laurene und Lara ",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("Laurene et Lara ",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
		"pc":
			if language == "german":
				return add_suffix("",WordHandler.get_words_string(word.german),verb.suffix.german[suffix_id])
			elif language == "french":
				return add_suffix("",WordHandler.get_words_string(word.french),verb.suffix.french[suffix_id])
	return WordHandler.get_words_string(word.german) if language == "german" else WordHandler.get_words_string(word.french)

func add_suffix(prefix: String,base: String, suffix: String):
	if base.contains("{INSERT}"):
		var parts = base.split("{INSERT}")
		parts.insert(1,suffix)
		var full = ""
		for part in parts:
			full += part
		return prefix + full + "."
	else:
		return prefix + base + " " + suffix + "."

func verb_in_category(verb: Verb):
	if verb.category == filter_category:
		return true
	return false

func select_next_verb_with_category(category: int) -> Dictionary:
	var all_verbs = Vars.verbs.values()
	filter_category = category
	var new_verbs = all_verbs.filter(verb_in_category)
	return select_next_verb(new_verbs)

func select_next_verb(new_verbs: Array) -> Dictionary:
	randomize()
	var selected_word: Word = null
	var selected_verb: Verb = null
	var min_score: int = -1
	new_verbs.shuffle()
	for verb in new_verbs:
		var this_words = []
		this_words.append(verb.infinitive)
		for version in verb.versions.values():
			this_words.append(version)
		this_words.shuffle()
		for word in this_words:
			if min_score == -1:
				min_score = (word as Word).learn_score
				selected_word = word
				selected_verb = verb
			if (word as Word).learn_score < min_score:
				min_score = (word as Word).learn_score
				selected_word = word
				selected_verb = verb
	return {
		"selected_word":selected_word,
		"selected_verb":selected_verb
		}

func get_compare_string(word: String, language: String) -> String:
	var is_correct: bool = false
	var clean_word = word.strip_edges()
	var edited_real_word = ""
	if language == "french":
		if clean_word.begins_with("une ") or clean_word.begins_with("la "):
			edited_real_word = clean_word.replace("une ","").replace("la ","")
		elif clean_word.begins_with("un ") or clean_word.begins_with("le "):
			edited_real_word = clean_word.replace("un ","").replace("le ","")
	elif language == "german":
		if clean_word.begins_with("der "):
			edited_real_word = clean_word.replace("der ","").replace("ein ","")
		elif clean_word.begins_with("die ") or clean_word.begins_with("eine "):
			edited_real_word = clean_word.replace("die ","").replace("eine ","")
		elif clean_word.begins_with("das "):
			edited_real_word = clean_word.replace("das ","").replace("ein ","")
		elif clean_word.begins_with("ein "):
			edited_real_word = clean_word.replace("das ","").replace("ein ","").replace("der ","")
	if edited_real_word == "":
		edited_real_word = clean_word
	edited_real_word = edited_real_word.replace("!","").replace("?","").replace(".","").replace("œ","oe")
	return edited_real_word

func get_string_part(input: String, from: int, to: int):
	var output: String = ""
	var id = 0
	for character in input:
		if id >= from:
			if id < to:
				output += character
		id += 1
	return output

func get_wrong_part(input: String, possible_words: Array,to: String):
	var picked_word = ""
	var similarity = -1.0
	
	for word in possible_words:
		var word_similarity = (word as String).similarity(input)
		if similarity == -1.0:
			picked_word = word
			similarity = word_similarity
		elif similarity < word_similarity:
			picked_word = word
			similarity = word_similarity
	var compare_correct = picked_word.to_lower()
	var compare_input = input.to_lower()
	
	var output = ""
	
	var remaining_input = compare_input
	
	var done = false
	var check_id = 0
	var offset = 0
	while done == false:
		var char_i = compare_input[check_id] if compare_input.length() > 0 else ""
		var char_c = ""
		var char_c_orginal = ""
		
		var pair_i = ""
		if compare_input.length() > check_id + 1:
			pair_i = compare_input[check_id] + compare_input[check_id + 1]
		
		var pair_c = ""
		if compare_input.length() > check_id + 1:
			pair_c = compare_input[check_id] + compare_input[check_id + 1]
		
		if compare_correct.length() > (check_id):
			char_c_orginal = compare_correct[(check_id)]
		if compare_correct.length() > (check_id + offset):
			char_c = compare_correct[(check_id + offset)]
		else:
			done = true
			output += "[color=#f35b69][s]"
			output += remaining_input
			output += "[/s][/color]"
			continue
		if char_i == char_c:
			output += char_i
		else:
			var remaining_correct = get_string_part(compare_correct,check_id + offset,compare_correct.length())
			var search_id = remaining_correct.find(pair_i)
			if search_id != -1:
				output += "[color=#39b374][u]"
				output += get_string_part(remaining_correct,0,search_id)
				output += "[/u][/color]"
				output += char_i
				offset += search_id
			else:
				output += "[color=#f35b69][s]"
				output += char_i
				output += "[/s][/color]"
				offset -= 1
		remaining_input = remaining_input.trim_prefix(remaining_input[0]) if compare_input.length() > 0 else ""
		check_id += 1
		if check_id >= compare_input.length():
			done = true
	if compare_correct.length() >= check_id + offset:
		var remaining_correct = get_string_part(compare_correct,check_id + offset,compare_correct.length())
		output += "[color=#39b374][u]"
		output += remaining_correct
		output += "[/u][/color]"
	return output

func get_words_in_unit(unit: int) -> Array:
	searching_unit = unit
	var new_array = Vars.words.filter(word_in_unit)
	return new_array

func select_next_word_in_unit(unit: int, not_uids: Array = []) -> Word:
	return select_next_word_from_words(get_words_in_unit(unit), not_uids)

func select_next_word_until_unit(unit: int) -> Word:
	return select_next_word_from_words(get_words_until_unit(unit))

func select_next_word_in_unit_with_type(unit: int, type: int) -> Word:
	if select_next_word_from_words(get_words_with_type_in_unit(unit,type)) == null:
		var word = Word.new()
		word.french = ["**Fehlende Daten**"]
		word.german = ["**Fehlende Daten**"]
		return word
	return select_next_word_from_words(get_words_with_type_in_unit(unit,type))

func select_next_word_until_unit_with_type(unit: int, type: int) -> Word:
	if select_next_word_from_words(get_words_with_type_until_unit(unit,type)) == null:
		var word = Word.new()
		word.french = ["**Fehlende Daten**"]
		word.german = ["**Fehlende Daten**"]
		return word
	return select_next_word_from_words(get_words_with_type_until_unit(unit,type))


func select_next_word_in_unit_for_review(unit: int) -> Word:
	return select_next_review_word_from_words(get_words_in_unit(unit))

func select_next_word_until_unit_for_review(unit: int) -> Word:
	return select_next_review_word_from_words(get_words_until_unit(unit))


func select_next_word_from_words(words: Array, not_uids: Array = []) -> Word:
	var lowest_score = -1
	var open_words = []
	for word in words:
		if !word.uid in not_uids:
			var word_score = word.learn_score
			if lowest_score == -1:
				open_words = [word]
				lowest_score = word_score
			elif word_score < lowest_score:
				open_words = [word]
				lowest_score = word_score
			elif word_score == lowest_score:
				open_words.append(word)
	if open_words:
		return open_words.pick_random()
	else:
		return null

func select_next_review_word_from_words(words: Array) -> Word:
	var lowest_score = -1
	var open_words = []
	for word in words:
		
		var word_score = word.learn_score / 2
		if word.trys > 0:
			word_score += ((word.learn_score / 2) * word.trys_correct / word.trys)
		
		if word in Vars.marked_words:
			word_score /= 3
		
		if lowest_score == -1:
			open_words = [word]
			lowest_score = word_score
		elif word_score < lowest_score:
			open_words = [word]
			lowest_score = word_score
		elif word_score == lowest_score:
			open_words.append(word)
	return open_words.pick_random()

func select_next_words_in_unit(unit: int,amount: int,until: bool = false,other: Array = []) -> Array:
	var words: Array
	if until == false:
		words = get_words_in_unit(unit)
	else:
		words = get_words_until_unit(unit)
	if other.size() >= 1:
		words = other
	if amount > words.size():
		print("Not enough words in unit ", unit, " for selecting next ", amount, "words!" )
		return []
	var selected_words = []
	while selected_words.size() < amount:
		var lowest_score = -1
		var open_words = []
		words.shuffle()
		for word in words:
			if not word in selected_words:
				var word_score = word.learn_score
				if lowest_score == -1:
					
					lowest_score = word_score
					open_words.append(word)
				elif word_score < lowest_score:
					open_words = [word]
					lowest_score = word_score
				elif word_score == lowest_score:
					open_words.append(word)
		selected_words.append_array(open_words)
	selected_words.resize(amount)
	return selected_words

func is_correct_match(word: Word, with: Word) -> bool:
	if check_correct(word.french[0],with.french,"fr") or check_correct(word.german[0],with.german,"de"):
		return true
	else:
		return false

func word_has_type(word: Word):
	if word.sentence_type == filter_type:
		return true if filter_invert == false else false
	else:
		return false if filter_invert == false else true

func get_words_with_type_in_unit(unit: int,type: int, invert: bool = false,override_words = []) -> Array:
	filter_type = type
	filter_invert = invert
	var words = get_words_in_unit(unit) if !override_words else override_words
	var filtered = words.filter(word_has_type)
	return filtered

func get_words_with_type_until_unit(unit: int,type: int, invert: bool = false) -> Array:
	filter_type = type
	filter_invert = invert
	var words = get_words_until_unit(unit)
	var filtered = words.filter(word_has_type)
	return filtered
