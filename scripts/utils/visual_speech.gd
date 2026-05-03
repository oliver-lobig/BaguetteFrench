@tool
extends Node

enum sounds {A,L,E,TH,T,V,M,NEUTRAL,O,OO}

var characters = {
	"a":sounds.A,
	"b":sounds.M,
	"c":sounds.L,
	"d":sounds.TH,
	"e":sounds.A,
	"f":sounds.V,
	"g":sounds.T,
	"h":sounds.E,
	"i":sounds.OO,
	"j":sounds.L,
	"k":sounds.E,
	"l":sounds.L,
	"m":sounds.M,
	"n":sounds.T,
	"o":sounds.O,
	"p":sounds.M,
	"q":sounds.E,
	"r":sounds.O,
	"s":sounds.L,
	"t":sounds.T,
	"u":sounds.OO,
	"v":sounds.V,
	"w":sounds.V,
	"x":sounds.E,
	"y":sounds.OO,
	"z":sounds.L,
	"é":sounds.A,
	"è":sounds.E,
	"ê":sounds.E,
	"á":sounds.A,
	"à":sounds.A,
	"â":sounds.A,
	"ç":sounds.T,
	"œ":sounds.O,
	"ë":sounds.E,
	" ":sounds.NEUTRAL
}

func get_sounds(input: String) -> Array:
	var output: Array = []
	for character in input:
		if character in characters.keys():
			output.append(characters.get(character))
	return output
