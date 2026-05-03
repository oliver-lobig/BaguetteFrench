@tool
extends Node

enum Units {UNSET,BIENVENUE,LA_VIE,MES_COPAINS_ET_MOI,ANNIVERSAIRE,ACTIVITES,THEATRE,NOEL,L_ECOLE,MOIS_ET_JOURS_DE_LA_SEMAINE,LA_FAMILLE,VACANCES,RENTREE,ADVENTURES,EN_FAMILLE,MANGER,BREIZH,LES_MEDIAS,LA_COULEUR}

enum SentenceTypes {UNSET,VERB,ADJECTIVE,NOUN,PERSONAL_PRONOUN,NOTHING,COMPLETE}

enum GrammaticalGenders {UNSET,FEMALE,MALE,NONE}

enum FieldTypes {LEARNING,LISTEN_AND_SPEEK,MATCH,SINGLE_VOCAB,SENTENCES,REPETITION,GEM,VERBS}

var possible_extra_field_types: Array = [
	FieldTypes.LISTEN_AND_SPEEK,
	FieldTypes.MATCH,
	FieldTypes.SINGLE_VOCAB,
	FieldTypes.SENTENCES
]

var unit_sequence: Array = [
	Units.BIENVENUE,
	Units.LA_VIE,
	Units.ANNIVERSAIRE,
	Units.MES_COPAINS_ET_MOI,
	Units.ACTIVITES,
	Units.THEATRE,
	Units.NOEL,
	Units.L_ECOLE,
	Units.MOIS_ET_JOURS_DE_LA_SEMAINE,
	Units.LA_FAMILLE,
	Units.VACANCES,
	Units.LA_COULEUR,
	Units.RENTREE,
	Units.ADVENTURES,
	Units.EN_FAMILLE,
	Units.MANGER,
	Units.BREIZH
]

var unit_names: Dictionary = {
	Units.UNSET:"!!! UNSET !!!",
	Units.BIENVENUE:"Bienvenue!",
	Units.LA_VIE:"Ma Vie",
	Units.MES_COPAINS_ET_MOI:"Mes Copains et moi",
	Units.ANNIVERSAIRE:"Mon Anniversaire",
	Units.ACTIVITES:"Les Activiés",
	Units.THEATRE:"Un Spectacle au Théâtre",
	Units.NOEL:"La Fête de Noël",
	Units.L_ECOLE:"L'École",
	Units.MOIS_ET_JOURS_DE_LA_SEMAINE:"Les Mois et les Jours de la Semaine",
	Units.LA_FAMILLE:"La Famille",
	Units.VACANCES:"Les Vacances",
	Units.RENTREE:"La Rentrée au classes",
	Units.ADVENTURES:"Mes Adventures sous la Terre",
	Units.EN_FAMILLE:"En Famille",
	Units.MANGER:"On Mange",
	Units.BREIZH:"Bienvenue au Breizh",
	Units.LES_MEDIAS:"Les Medias",
	Units.LA_COULEUR: "Les Couleurs"
}
