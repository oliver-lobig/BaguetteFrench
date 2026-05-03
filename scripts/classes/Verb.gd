extends Resource
class_name Verb

@export var versions = {
	"s1":Word.new(),
	"s2":Word.new(),
	"s3":Word.new(),
	"p1":Word.new(),
	"p2":Word.new(),
	"p3":Word.new(),
	"pc":Word.new()
}

@export var suffix = {
	"german":[],
	"french":[]
}

@export var infinitive: Word = Word.new()

@export var uid: int = 0

@export var category: int = 0
