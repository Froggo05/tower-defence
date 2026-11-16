class_name UID extends Node
#Place where all unique IDs are created
static var UIDCOUNT: int = 0

static func GENERATEUINIQUEIDENTIFIER()->int:
	UIDCOUNT += 1
	var nextIUID = hash(rand_from_seed(UIDCOUNT))
	return nextIUID
