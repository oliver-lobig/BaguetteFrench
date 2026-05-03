@tool
extends Node

var default_normal_font: Font = preload("uid://dna6xdacyw8ku") # 1 (aka. Medium)
var default_regular_font: Font = preload("uid://bi0vm20b5q20n") # 2
var default_semi_bold_font: Font = preload("uid://c7v0k1jemstg6") # 3
var default_bold_font: Font = preload("uid://bqcfhrj22chhj") # 4
var default_italic_font: Font = preload("uid://btnssh7pimwrb") # 5

#TITLE Variants
var default_title_normal_font: Font = preload("uid://c28jmi38h5xj7") # 1 (aka. Medium)
var default_title_regular_font: Font = preload("uid://c28jmi38h5xj7") # 2
var default_title_semi_bold_font: Font = preload("uid://x3f3cwp0msgk") # 3
var default_title_bold_font: Font = preload("uid://fxxd4654wo5e") # 4
var default_title_italic_font: Font = preload("uid://c28jmi38h5xj7") # 5

enum FontUseType { DEFAULT, TITLE }

func get_default_font_with(font_type: int = 0, font_use: int = 0) -> Font:
	if font_use == FontUseType.DEFAULT:
		if font_type == 0:
			return default_normal_font
		elif font_type == 1:
			return default_regular_font
		elif font_type == 2:
			return default_semi_bold_font
		elif font_type == 3:
			return default_bold_font
		elif font_type == 4:
			return default_italic_font
	elif font_use == FontUseType.TITLE:
		if font_type == 0:
			return default_title_normal_font
		elif font_type == 1:
			return default_title_regular_font
		elif font_type == 2:
			return default_title_semi_bold_font
		elif font_type == 3:
			return default_title_bold_font
		elif font_type == 4:
			return default_title_italic_font
	printerr(font_type, " is not a valid font-type!")
	printerr(font_use, " is not a valid font-use!")
	return default_normal_font
