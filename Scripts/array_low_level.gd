extends Node

class_name array_low_level

const MAX_WORD_SIZE := 32
const MAX_GUESSED := 32
var hidden := []
var hidden_size := 0
var guessed_letters := []
var guessed_size := 0

func clear_hidden():
	for i in range(hidden_size):
		hidden[i] = ""
	hidden_size = 0
	
func clear_guessed():
	for i in range(guessed_size):
		guessed_letters[i] = ""
	guessed_size = 0

func hidden_push(value):
	if hidden_size >= MAX_WORD_SIZE:
		print("HIDDEN OVERFLOW")
		return
	hidden[hidden_size] = str(value)
	hidden_size += 1

func guessed_push(value):
	if guessed_size >= MAX_GUESSED:
		print("GUESSED OVERFLOW")
		return
	guessed_letters[guessed_size] = str(value)
	guessed_size += 1

func guessed_checker(letter) -> bool:
	for i in range(guessed_size):
		if guessed_letters[i] == letter:
			return true
	return false

func build_hidden() -> String:
	var out := " "
	for i in range(hidden_size):
		var ch = hidden[i]
		if ch == null:
			ch = ""
		out += ch
		if i < hidden_size - 1:
			out += " "
	return out

func build_guessed() -> String:
	var out := " "
	var first := true
	for i in range(guessed_size):
		var ch = guessed_letters[i]
		if ch == null || ch == "":
			continue
		if not first:
			out += ", "
		out += ch
		first = false
		#if i < guessed_size - 1:
			#out += ", "
	return out
