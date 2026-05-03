extends Node
var grammatical_gender: int = -1

func get_sentence_from_all(count: int = 1):
	return get_sentence_from_words(Vars.words,count)

func is_grammatical_gender(word):
	return word.grammatical_gender == grammatical_gender

func get_sentence_from_words(words: Array,count: int):
	randomize()
	grammatical_gender = randi_range(1,2)
	
	randomize()
	var nouns = WordHandler.get_words_with_type_in_unit(1,3,false,words)
	var possible_nouns = nouns.filter(is_grammatical_gender)
	
	
	randomize()
	var verbs = WordHandler.get_words_with_type_in_unit(1,1,false,words)
	
	
	randomize()
	var adjectives = WordHandler.get_words_with_type_in_unit(1,2,false,words)
	var possible_adjective = adjectives.filter(is_grammatical_gender)
	
	
	
	var text = """"""
	for i in range(20):
		randomize()
		var noun = possible_nouns.pick_random().french[0]
		var verb = verbs.pick_random().french[0]
		var adjective = possible_adjective.pick_random().french[0]
		var sentence: String = (noun.capitalize() + " " + adjective + " " + verb)
		text += sentence
		if !text.ends_with("."):
			text += "."
		text += " "
	return text
