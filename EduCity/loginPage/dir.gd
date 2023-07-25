extends Node2D

func _ready():
	var dir = DirAccess.open("user://")
	dir.make_dir("LearningPage")
	dir.make_dir("LearningPage/LearningResources")
	print("copy")
	dir.copy("res://Config/quizConfig.json","user://quizConfig.json")
	copy_directory_recursively("res://LearningPage/LearningResources","user://LearningPage/LearningResources")

# copy whole folder from res:// to user://
static func copy_directory_recursively(p_from : String, p_to : String) -> void:
	var directory = DirAccess.open(p_from)
	var dirTo = DirAccess.open(p_to)

	directory.list_dir_begin()
	var file_name = directory.get_next()

	while (file_name != "" && file_name != "." && file_name != ".."):
		var full_path_from = p_from + "/" + file_name
		var full_path_to = p_to + "/" + file_name
		
		if directory.current_is_dir():
			dirTo.make_dir_recursive(full_path_to)
			copy_directory_recursively(full_path_from, full_path_to)
		else:
			dirTo.make_dir_recursive(p_to)
			directory.copy(full_path_from, full_path_to)
			
		file_name = directory.get_next()
